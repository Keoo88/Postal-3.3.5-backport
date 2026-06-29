local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_QuickAttach = Postal:NewModule("QuickAttach", "AceHook-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_QuickAttach.description = L["Allows you to quickly attach different trade items types to a mail."]
Postal_QuickAttach.description2 = L[ [[|cFFFFCC00*|r A default recipient name can be specified by right clicking on a button.
|cFFFFCC00*|r Which bags are used by this feature can be set in the main menu.]] ]

-- This module is WotLK 3.3.5a only. Retail/Classic/BCC/Cata/MoP code paths and the
-- C_Container / numeric classID API (which does not exist in 3.3.5a) have been removed.
-- Trade Goods item subTypes are matched by their localized name returned from GetItemInfo().

local QAButtonDialogInfo = "" -- Name|classID|subclassID
local QAButtons
local WotLKClassName -- cached localized class name (e.g. "Trade Goods")
local WotLKSubTypeNames -- cached localized sub-type names per subclassID

-- Positioning constants. Matches the Postal+ reference so the bar is anchored
-- ("glued") to the top-right of the send-mail frame instead of floating.
local QA_ANCHOR_X = -43
local QA_ANCHOR_Y = -25
local QA_BUTTON_GAP = 37
local QA_SCALE = 0.73

-- Reference items used to resolve the localized sub-type name for each subclassID.
local SUBTYPE_REFS = {
	[5]  = {2996, 4339, 33470, 41511}, -- Cloth
	[6]  = {2318, 4234, 4304, 21887}, -- Leather
	[7]  = {2770, 2771, 2772, 23424, 36909, 36913}, -- Metal & Stone
	[8]  = {31737, 43015, 43013, 33454, 35953}, -- Cooking
	[9]  = {33614, 37921, 36901, 36904, 36905}, -- Herb
	[12] = {34054, 34055, 34057, 22445, 22573, 16204}, -- Enchanting
	[4]  = {20824, 32227, 32228, 32229, 32230, 32231, 36917, 36920, 36921}, -- Jewelcrafting
	[1]  = {23783, 23784, 23785, 23786, 23787, 32396}, -- Parts
	[10] = {22572, 22574, 22575, 22576, 22577, 22578}, -- Elemental
	[3]  = {32399, 32400, 32401, 32402, 32403}, -- Devices
	[2]  = {4364, 4371, 7191, 10648, 18631}, -- Explosives
	[11] = {4289, 4305, 6260, 6261, 10305, 10306}, -- Other
	[13] = {39690, 39691, 36783, 35625, 35627}, -- Materials
	[14] = {33803, 33802, 29736, 38848, 33809}, -- Armor Enchantment
	[15] = {33804, 38973, 38974, 38978, 38979}, -- Weapon Enchantment
}

-- Resolve and cache the localized class/sub-type names from the game's item cache.
local function BuildWotLKItemNames()
	if not WotLKClassName then
		WotLKClassName = select(6, GetItemInfo(34054)) -- Infinite Dust -> "Trade Goods" (localized)
	end
	if not WotLKSubTypeNames then
		WotLKSubTypeNames = {}
	end
	for scID, itemIDs in pairs(SUBTYPE_REFS) do
		if not WotLKSubTypeNames[scID] then
			for _, itemID in ipairs(itemIDs) do
				local subType = select(7, GetItemInfo(itemID))
				if subType then
					WotLKSubTypeNames[scID] = subType
					break
				end
			end
		end
	end
end

-- Set a button's GameTooltip
local function SetQAButtonGameTooltip(button, toolTip)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetText(toolTip,1,1,1,1,true)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end

-- Anchor a single button using the fixed layout. Used at both create and reposition
-- time so the bar never "snaps"/jitters between an initial and a final position.
local function PositionQAButton(button, index)
	if not button then return end
	button:ClearAllPoints()
	button:SetPoint("TOPLEFT", SendMailFrame, "TOPRIGHT", QA_ANCHOR_X, QA_ANCHOR_Y - QA_BUTTON_GAP * (index - 1))
end

-- Create a QuickAttach button. Buttons are created hidden and positioned once with
-- the final layout, then shown on MAIL_SHOW. This avoids the first-open flicker that
-- happened when the load-on-demand addon created+repositioned buttons mid-frame.
local function CreateQAButton(index, name, texture, classID, subclassID, toolTip)
	local button = CreateFrame("Button", name, SendMailFrame, "ActionButtonTemplate")
	button:SetScale(QA_SCALE)
	local icon = button.icon or _G[name.."Icon"]
	if icon then
		icon:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
	end
	button:RegisterForClicks("AnyUp")
	button:SetScript("OnClick", function(self, mouseButton) Postal_QuickAttachButtonClick(mouseButton, classID, subclassID) end)
	button:SetFrameLevel(button:GetFrameLevel() + 1)
	button:Hide()
	PositionQAButton(button, index)
	local charName = Postal_QuickAttachGetQAButtonCharName(classID, subclassID)
	if charName ~= "" then toolTip = toolTip.."\n"..L["Default recipient:"].." "..charName end
	SetQAButtonGameTooltip(button, toolTip)
end

-- Hide QuickAttach Buttons
local function Postal_QuickAttachHideButtons()
	if not QAButtons then return end
	for i = 1, #QAButtons do
		local button = _G[QAButtons[i][1]]
		if button then button:Hide() end
	end
end

-- Show QuickAttach Buttons
local function Postal_QuickAttachShowButtons()
	if not QAButtons then return end
	for i = 1, #QAButtons do
		local button = _G[QAButtons[i][1]]
		if button then button:Show() end
	end
end

-- Re-anchor every button using the fixed layout.
local function Postal_QuickAttach_Reposition()
	if not QAButtons then return end
	for i = 1, #QAButtons do
		PositionQAButton(_G[QAButtons[i][1]], i)
	end
end

-- Create QuickAttach buttons and hook OnClick events
function Postal_QuickAttach:OnEnable()
	if not Postal_QuickAttachButton1 then
		QAButtons = {}
		BuildWotLKItemNames()
		table.insert(QAButtons, {"Postal_QuickAttachButton1", "Interface\\Icons\\Trade_Tailoring", 7, 5, L["Cloth"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton2", "Interface\\Icons\\INV_Misc_LeatherScrap_02", 7, 6, L["Leather"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton3", "Interface\\Icons\\Trade_Mining", 7, 7, L["Metal & Stone"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton4", "Interface\\Icons\\INV_Misc_Food_15", 7, 8, L["Cooking"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton5", "Interface\\Icons\\Trade_Herbalism", 7, 9, L["Herb"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton6", "Interface\\Icons\\Trade_Engraving", 7, 12, L["Enchanting"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton7", "Interface\\Icons\\INV_Misc_Gem_01", 7, 4, L["Jewelcrafting"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton8", "Interface\\Icons\\INV_Gizmo_FelIronCasing", 7, 1, L["Parts"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton9", "Interface\\Icons\\INV_Elemental_Primal_Air", 7, 10, L["Elemental"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton10", "Interface\\Icons\\inv_gizmo_goblingtonkcontroller", 7, 3, L["Devices"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton11", "Interface\\Icons\\INV_Misc_Ammo_Gunpowder_01", 7, 2, L["Explosives"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton12", "Interface\\Icons\\INV_Elemental_Primal_Nether", 7, 13, L["Materials"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton13", "Interface\\Icons\\INV_Misc_Rune_09", 7, 11, L["Other"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton14", "Interface\\Icons\\INV_Scroll_03", 7, 14, L["Armor Enchantment"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton15", "Interface\\Icons\\INV_Weapon_Shortblade_05", 7, 15, L["Weapon Enchantment"]})
		table.insert(QAButtons, {"Postal_QuickAttachButton16", "Interface\\Icons\\Ability_Ensnare", 7, -1, L["Trade Goods"]})
		for i = 1, #QAButtons do
			CreateQAButton(i, QAButtons[i][1], QAButtons[i][2], QAButtons[i][3], QAButtons[i][4], QAButtons[i][5])
		end
	end
	self:RegisterEvent("MAIL_SHOW")
	-- If the mailbox is already open when the module is enabled (load-on-demand), lay out now.
	if MailFrame and MailFrame:IsVisible() then
		self:MAIL_SHOW()
	end
end

-- Reposition and show the bar every time the mailbox opens so it is always anchored correctly.
function Postal_QuickAttach:MAIL_SHOW()
	Postal_QuickAttach_Reposition()
	Postal_QuickAttachShowButtons()
end

-- Disabling modules unregisters all events/hook automatically
function Postal_QuickAttach:OnDisable()
	Postal_QuickAttach:UnregisterAllEvents()
	Postal_QuickAttachHideButtons()
end

-- Return how many free item slots are in the current send mail
local function SendMailNumberOfFreeSlots()
	local NumberOfFreeSlots = ATTACHMENTS_MAX_SEND
	for itemIndex = 1, ATTACHMENTS_MAX_SEND do
		if GetSendMailItem(itemIndex) then
			NumberOfFreeSlots = NumberOfFreeSlots - 1
		end
	end
	return NumberOfFreeSlots
end

-- Take an action based on a QuickAttach button click
function Postal_QuickAttachButtonClick(mouseButton, classID, subclassID)
	if (mouseButton == "LeftButton") then Postal_QuickAttachLeftButtonClick(classID, subclassID) end
	if (mouseButton == "RightButton") then Postal_QuickAttachRightButtonClick(classID, subclassID) end
end

-- Attach as many items as possible of the specified type to the current send mail.
function Postal_QuickAttachLeftButtonClick(classID, subclassID)
	BuildWotLKItemNames()

	local name = Postal_QuickAttachGetQAButtonCharName(classID, subclassID)
	if name ~= "" then
		SendMailNameEditBox:SetText(name)
		SendMailNameEditBox:HighlightText()
	end

	-- Resolve the localized sub-type name we are matching against for this button.
	local targetSubType = WotLKSubTypeNames[subclassID]
	if not targetSubType then
		for _, btn in ipairs(QAButtons) do
			if btn[3] == classID and btn[4] == subclassID then
				targetSubType = btn[5]
				break
			end
		end
	end

	for bagID = 0, NUM_BAG_FRAMES do
		if Postal.db.profile.QuickAttach["EnableBag"..bagID] then
			local numberOfSlots = GetContainerNumSlots(bagID)
			for slotIndex = 1, numberOfSlots do
				local locked = select(3, GetContainerItemInfo(bagID, slotIndex)) == 1
				if not locked then
					local link = GetContainerItemLink(bagID, slotIndex)
					if link then
						local itemID = tonumber(strmatch(link, "item:(%d+)"))
						if itemID then
							local _, _, _, _, _, itemType, itemSubType = GetItemInfo(itemID)
							if itemType and WotLKClassName and itemType == WotLKClassName then
								-- subclassID == -1 means "any Trade Goods".
								if subclassID == -1 or itemSubType == targetSubType then
									if SendMailNumberOfFreeSlots() > 0 then
										PickupContainerItem(bagID, slotIndex)
										ClickSendMailItemButton()
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

-- Set the default recipient name to be filled in for the specified type.
function Postal_QuickAttachRightButtonClick(classID, subclassID)
	local name = Postal_QuickAttachGetQAButtonCharName(classID, subclassID)
	QAButtonDialogInfo = name.."|"..classID.."|"..subclassID
	StaticPopup_Show("POSTAL_QUICKATTACH_CHARACTER_NAME")
end

-- Check if a default character name for the specified type has been set and return it.
function Postal_QuickAttachGetQAButtonCharName(classID, subclassID)
	local db = Postal.db.profile
	if not (db.QuickAttach) then return "" end
	if not (db.QuickAttach.QAbuttons) then return "" end
	db = Postal.db.profile.QuickAttach.QAbuttons
	for i = #db, 1, -1 do
		local n, c, s = strsplit("|", db[i])
		if tonumber(c) == tonumber(classID) and tonumber(s) == tonumber(subclassID) then
			return n
		end
	end
	return ""
end

-- Set and store a default character name for the specified type.
local function Postal_QuickAttachSetQAButtonCharName(name, classID, subclassID)
	local db = Postal.db.profile
	local buttonString = ("%s|%s|%s"):format(name, classID, subclassID)
	if not (db.QuickAttach) then db.QuickAttach = {} end
	if not (db.QuickAttach.QAbuttons) then db.QuickAttach.QAbuttons = {} end
	db = Postal.db.profile.QuickAttach.QAbuttons
	for i = #db, 1, -1 do
		local n, c, s = strsplit("|", db[i])
		if tonumber(c) == tonumber(classID) and tonumber(s) == tonumber(subclassID) then
			tremove(db, i)
		end
	end
	if name ~= "" then tinsert(db, buttonString) end
	table.sort(db)
	if #db == 0 then wipe(Postal.db.profile.QuickAttach) end
	for i = 1, #QAButtons do
		local c, s, t = QAButtons[i][3], QAButtons[i][4], QAButtons[i][5]
		if tonumber(c) == tonumber(classID) and tonumber(s) == tonumber(subclassID) then
			if name ~= "" then t = t.."\n"..L["Default recipient:"].." "..name end
			SetQAButtonGameTooltip(_G[QAButtons[i][1]], t)
		end
	end
end

-- Define static popup for default character name dialog.
StaticPopupDialogs["POSTAL_QUICKATTACH_CHARACTER_NAME"] = {
	text = L["Default recipient:"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	maxLetters = 128,
	editBoxWidth = 350,
	OnAccept = function(self)
		local name, classID, subclassID = strsplit("|", QAButtonDialogInfo)
		name = strtrim(self.editBox:GetText())
		Postal_QuickAttachSetQAButtonCharName(name, classID, subclassID)
	end,
	OnShow = function(self)
		local name, classID, subclassID = strsplit("|", QAButtonDialogInfo)
		self.editBox:SetText(name)
		self.editBox:HighlightText()
		self.editBox:SetFocus()
	end,
	OnHide = StaticPopupDialogs["SET_GUILDPLAYERNOTE"].OnHide,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent()
		local name, classID, subclassID = strsplit("|", QAButtonDialogInfo)
		name = strtrim(parent.editBox:GetText())
		Postal_QuickAttachSetQAButtonCharName(name, classID, subclassID)
		parent:Hide()
	end,
	EditBoxOnEscapePressed = StaticPopupDialogs["SET_GUILDPLAYERNOTE"].EditBoxOnEscapePressed,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

-- Create QuickAttach Menu
function Postal_QuickAttach.ModuleMenu(self, level)
	if not level then return end
	local info = self.info
	wipe(info)
	info.isNotRadio = 1
	if level == 1 + self.levelAdjust then
		info.keepShownOnClick = 1

		info.text = L["Enable for backpack"]
		info.func = Postal.SaveOption
		info.arg1 = "QuickAttach"
		info.arg2 = "EnableBag0"
		info.checked = Postal.db.profile.QuickAttach.EnableBag0
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Enable for bag one"]
		info.func = Postal.SaveOption
		info.arg1 = "QuickAttach"
		info.arg2 = "EnableBag1"
		info.checked = Postal.db.profile.QuickAttach.EnableBag1
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Enable for bag two"]
		info.func = Postal.SaveOption
		info.arg1 = "QuickAttach"
		info.arg2 = "EnableBag2"
		info.checked = Postal.db.profile.QuickAttach.EnableBag2
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Enable for bag three"]
		info.func = Postal.SaveOption
		info.arg1 = "QuickAttach"
		info.arg2 = "EnableBag3"
		info.checked = Postal.db.profile.QuickAttach.EnableBag3
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Enable for bag four"]
		info.func = Postal.SaveOption
		info.arg1 = "QuickAttach"
		info.arg2 = "EnableBag4"
		info.checked = Postal.db.profile.QuickAttach.EnableBag4
		UIDropDownMenu_AddButton(info, level)
	end
end
