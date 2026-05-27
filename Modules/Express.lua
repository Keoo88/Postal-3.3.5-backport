local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_Express = Postal:NewModule("Express", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_Express.description = L["Mouse click short cuts for mail."]
Postal_Express.description2 = L[ [[|cFFFFCC00*|r Shift-Click to take item/money from mail.
|cFFFFCC00*|r Ctrl-Click to return mail.
|cFFFFCC00*|r Alt-Click to move an item from your inventory to the current outgoing mail (same as right click in default UI).]] ]

local _G = getfenv(0)
local processingBagClick = false

function Postal_Express:MAIL_SHOW()
	DEFAULT_CHAT_FRAME:AddMessage("DBG: MAIL_SHOW fired")
	-- Debug: check what bag frames/buttons exist
	for bag = 0, NUM_BAG_FRAMES do
		local frame = _G["ContainerFrame"..(bag+1)]
		if frame then
			local btn1 = _G["ContainerFrame"..(bag+1).."Item1"]
			DEFAULT_CHAT_FRAME:AddMessage("DBG: ContainerFrame"..(bag+1).." exists, Item1="..tostring(btn1))
		end
	end
	if Postal.db.profile.Express.EnableAltClick then
		if not self:IsHooked(GameTooltip, "OnTooltipSetItem") then
			self:HookScript(GameTooltip, "OnTooltipSetItem")
		end
		if not self:IsHooked("PickupContainerItem") then
			self:RawHook("PickupContainerItem", true)
			DEFAULT_CHAT_FRAME:AddMessage("DBG: PickupContainerItem hooked")
		end
		if not self:IsHooked("ContainerFrameItemButton_OnClick") then
			self:RawHook("ContainerFrameItemButton_OnClick", true)
			DEFAULT_CHAT_FRAME:AddMessage("DBG: ContainerFrameItemButton_OnClick hooked")
		end
		-- Hook Blizzard bag buttons (ContainerFrame1Item1 through ContainerFrame5ItemN)
		for bag = 0, NUM_BAG_FRAMES do
			local frame = _G["ContainerFrame"..(bag+1)]
			if frame then
				for slot = 1, GetContainerNumSlots(bag) do
					local btn = _G["ContainerFrame"..(bag+1).."Item"..slot]
					if btn and not self:IsHooked(btn, "OnClick") then
						self:RawHookScript(btn, "OnClick", function(button, btnName, ...)
							DEFAULT_CHAT_FRAME:AddMessage("DBG: Per-button OnClick bag="..bag.." slot="..slot.." btn="..tostring(btnName).." alt="..tostring(IsAltKeyDown()).." ctrl="..tostring(IsControlKeyDown()))
							return self.hooks[button].OnClick(button, btnName, ...)
						end)
					end
				end
			end
		end
	end
	self:RegisterEvent("MAIL_CLOSED", "Reset")
	self:RegisterEvent("PLAYER_LEAVING_WORLD", "Reset")
end

function Postal_Express:Reset(event)
	if self:IsHooked(GameTooltip, "OnTooltipSetItem") then
		self:Unhook(GameTooltip, "OnTooltipSetItem")
	end
	if self:IsHooked("PickupContainerItem") then
		self:Unhook("PickupContainerItem")
	end
	processingBagClick = false
	self:UnregisterEvent("BAG_UPDATE")
	self:UnregisterEvent("MAIL_CLOSED")
	self:UnregisterEvent("PLAYER_LEAVING_WORLD")
end

function Postal_Express:OnEnable()
	self:RawHook("InboxFrame_OnClick", true)
	self:RawHook("InboxFrame_OnModifiedClick", "InboxFrame_OnClick", true) -- Eat all modified clicks too
	self:RawHook("InboxFrameItem_OnEnter", true)

	self:RegisterEvent("MAIL_SHOW")
	if MailFrame:IsVisible() then
		self:MAIL_SHOW()
	end
end

function Postal_Express:OnDisable()
	local module = self or Postal_Express
	if module:IsHooked(GameTooltip, "OnTooltipSetItem") then
		module:Unhook(GameTooltip, "OnTooltipSetItem")
	end
	if module:IsHooked("PickupContainerItem") then
		module:Unhook("PickupContainerItem")
	end
	if module:IsHooked("InboxFrame_OnClick") then
		module:Unhook("InboxFrame_OnClick")
	end
	if module:IsHooked("InboxFrame_OnModifiedClick") then
		module:Unhook("InboxFrame_OnModifiedClick")
	end
	if module:IsHooked("InboxFrameItem_OnEnter") then
		module:Unhook("InboxFrameItem_OnEnter")
	end
	module:UnregisterAllEvents()
end

local Postal_Express_cTip = CreateFrame("GameTooltip",'MailBagScanTooltip',nil,"GameTooltipTemplate")
local function Postal_Express_IsSoulbound(bag, slot)
    Postal_Express_cTip:SetOwner(UIParent, "ANCHOR_NONE")
    Postal_Express_cTip:SetBagItem(bag, slot)
    Postal_Express_cTip:Show()
    for i = 1,Postal_Express_cTip:NumLines() do
		local str = _G['MailBagScanTooltipTextLeft' .. i]
		if str and (str:GetText() == ITEM_SOULBOUND) then
            return true
        end
    end
    Postal_Express_cTip:Hide()
    return false
end

function Postal_Express:InboxFrameItem_OnEnter(this, motion)
	self.hooks["InboxFrameItem_OnEnter"](this, motion)
	local tooltip = GameTooltip

	local money, COD, _, hasItem, _, wasReturned, _, canReply = select(5, GetInboxHeaderInfo(this.index))
	if Postal.db.profile.Express.MultiItemTooltip and hasItem and hasItem > 1 then
		for i = 1, ATTACHMENTS_MAX_RECEIVE do
			local name, itemTexture, count, quality, canUse = GetInboxItem(this.index, i);
			if name then
				local itemLink = GetInboxItemLink(this.index, i) or name
				local tex = itemTexture and ("\124T%s:0\124t "):format(itemTexture) or ""
				if count > 1 then
					tooltip:AddLine(("%s%sx%d"):format(tex, itemLink, count))
				else
					tooltip:AddLine(("%s%s"):format(tex, itemLink))
				end
			end
		end
	end
	if (money > 0 or hasItem) and (not COD or COD == 0) then
		tooltip:AddLine(L["|cffeda55fShift-Click|r to take the contents."])
	end
	if not wasReturned and canReply then
		tooltip:AddLine(L["|cffeda55fCtrl-Click|r to return it to sender."])
	end
	tooltip:Show()
end

function Postal_Express:InboxFrame_OnClick(button, index)
	if IsShiftKeyDown() then
		local cod = select(6, GetInboxHeaderInfo(index))
		if cod <= 0 then
			AutoLootMailItem(index)
		end
		--button:SetChecked(not button:GetChecked())
	elseif IsControlKeyDown() then
		local wasReturned, _, canReply = select(10, GetInboxHeaderInfo(index))
		if not wasReturned and canReply then
			ReturnInboxItem(index)
		end
	else
		return self.hooks["InboxFrame_OnClick"](button, index)
	end
end

function Postal_Express:OnTooltipSetItem(tooltip, ...)
	local recipient = SendMailNameEditBox:GetText()
	if Postal.db.profile.Express.AutoSend and recipient ~= "" and SendMailFrame:IsVisible() and not CursorHasItem() then
		tooltip:AddLine(string.format(L["|cffeda55fAlt-Click|r to send this item to %s."], recipient))
	end
	if Postal.db.profile.Express.BulkSend and SendMailFrame:IsVisible() and not CursorHasItem() then
		tooltip:AddLine(L["|cffeda55fControl-Click|r to attach similar items."])
	end
end

-- RawHook on PickupContainerItem — captures item info BEFORE the slot is emptied,
-- then calls the original, then processes Express Alt/Ctrl+Click logic.
-- Works for any bag UI (Blizzard, ElvUI, etc.) since all UIs call this to pick up items.
function Postal_Express:PickupContainerItem(bag, slot)
	if processingBagClick then
		self.hooks["PickupContainerItem"](bag, slot)
		return
	end

	if not SendMailFrame:IsVisible() then
		self.hooks["PickupContainerItem"](bag, slot)
		DEFAULT_CHAT_FRAME:AddMessage("DBG: SendMailFrame not visible bag="..tostring(bag).." slot="..tostring(slot))
		return
	end

	DEFAULT_CHAT_FRAME:AddMessage("DBG: PickupContainerItem called bag="..tostring(bag).." slot="..tostring(slot).." alt="..tostring(IsAltKeyDown()).." ctrl="..tostring(IsControlKeyDown()))

	local texture, count, itemid, itemlocked
	if Postal.WOWBCClassic or Postal.WOWWotLKClassic then
		texture = select(1, GetContainerItemInfo(bag, slot))
		count = select(2, GetContainerItemInfo(bag, slot))
		itemlocked = select(3, GetContainerItemInfo(bag, slot)) == 1
		local link = GetContainerItemLink(bag, slot)
		if link then
			itemid = tonumber(strmatch(link, "(%d+)"))
		end
	end

	self.hooks["PickupContainerItem"](bag, slot)

	DEFAULT_CHAT_FRAME:AddMessage("DBG: texture="..tostring(texture).." count="..tostring(count).." itemid="..tostring(itemid).." alt="..tostring(IsAltKeyDown()).." ctrl="..tostring(IsControlKeyDown()))

	if IsAltKeyDown() and Postal.db.profile.Express.EnableAltClick and texture then
		DEFAULT_CHAT_FRAME:AddMessage("DBG: Alt+Click detected, attaching")
		ClickSendMailItemButton()
		if Postal.db.profile.Express.AutoSend and SendMailNameEditBox:GetText() ~= "" then
			for i = 1, ATTACHMENTS_MAX_SEND do
				local _, itemTexture, stackCount = GetSendMailItem(i)
				if itemTexture and texture == itemTexture and count == stackCount then
					SendMailFrame_SendMail()
				end
			end
		end
	elseif IsControlKeyDown() and Postal.db.profile.Express.BulkSend and itemid then
		DEFAULT_CHAT_FRAME:AddMessage("DBG: Ctrl+Click detected, bulk send")
		local itemq, _,_, itemc, itemsc, _, itemes = select(3,GetItemInfo(itemid))
		itemes = itemes and #itemes > 0
		if itemq and itemc then
			ClickSendMailItemButton()
			processingBagClick = true
			self:BulkSendLoop(itemid, itemlocked, itemq, itemc, itemsc, itemes)
			processingBagClick = false
		end
	end
end

-- Shared BulkSend loop: scan all bags and attach matching items
function Postal_Express:BulkSendLoop(itemid, itemlocked, itemq, itemc, itemsc, itemes)
	local itemsinmail = 0
	for iloop = 1, ATTACHMENTS_MAX_SEND do
		if GetSendMailItem(iloop) then itemsinmail = itemsinmail + 1 end
	end
	local scString = itemc.."."..(itemsc or "")
	local added = (itemlocked and 0) or -1
	for pass = 0,4 do
		local bmax = NUM_BAG_FRAMES
		if Postal.WOWRetail then
			bmax = bmax + NUM_REAGENTBAG_FRAMES
		end
		for b = 0,bmax do
			local numberOfSlots
			if Postal.WOWBCClassic or Postal.WOWWotLKClassic then
				numberOfSlots = GetContainerNumSlots(b)
			else
				numberOfSlots = C_Container.GetContainerNumSlots(b)
			end
			for s = 1, numberOfSlots do
				local tid
				if Postal.WOWBCClassic or Postal.WOWWotLKClassic then
					local link = GetContainerItemLink(b, s)
					if link then
						tid = tonumber(strmatch(link, "(%d+)"))
					end
				else
					tid = C_Container.GetContainerItemID(b, s)
				end
				local itemlocked2
				if Postal.WOWBCClassic or Postal.WOWWotLKClassic then
					itemlocked2 = select(3, GetContainerItemInfo(b,s)) == 1
				else
					if C_Container and C_Container.GetContainerItemInfo(b,s) then
						local itemInfo = C_Container.GetContainerItemInfo(b,s)
						itemlocked2 = itemInfo.isLocked
					else
						itemlocked2 = false
					end
				end
				if not tid or itemlocked2 or Postal_Express_IsSoulbound(b, s) then
					-- item locked, already attached, soulbound
				else
					local tq, _,_, tc, tsc, _, tes = select(3,GetItemInfo(tid))
					tsc = (tc or "").."."..(tsc or "")
					tes = tes and #tes > 0
					if (pass == 0 and itemq == 0 and tq == 0) -- vendor trash
					or (pass == 0 and itemq == 2 and tq == 2 and itemes and tes) -- green boe gear
					or (pass == 1 and tid == itemid) -- identical items
					or (pass == 2 and tsc == scString) -- same subtype
					or (pass == 3 and tc == itemc)   -- same type
					or (pass == 4 and tq == itemq)   -- same quality
					then
						ClearCursor()
						if Postal.WOWBCClassic or Postal.WOWWotLKClassic then
							PickupContainerItem(b, s)
						else
							C_Container.PickupContainerItem(b, s)
						end
						ClickSendMailItemButton()
						local itemlocked3
						if Postal.WOWBCClassic or Postal.WOWWotLKClassic then
							itemlocked3 = select(3, GetContainerItemInfo(b,s)) == 1
						else
							if C_Container and C_Container.GetContainerItemInfo(b,s) then
								local itemInfo = C_Container.GetContainerItemInfo(b,s)
								itemlocked3 = itemInfo.isLocked
							else
								itemlocked3 = false
							end
						end
						if itemlocked3 then -- now locked => added
							added = added + 1
							itemsinmail = itemsinmail + 1
							if itemsinmail >= ATTACHMENTS_MAX_SEND then
								ClearCursor()
								processingBagClick = false
								return
							end
						else -- failed
							ClearCursor()
						end
					end
				end
			end
		end
		if added >= 1 then break end
	end
	ClearCursor()
end

-- Hook on ContainerFrameItemButton_OnClick — catches clicks from XML bag buttons
-- and any code that calls this global function directly
function Postal_Express:ContainerFrameItemButton_OnClick(frame, button, ...)
	DEFAULT_CHAT_FRAME:AddMessage("DBG: ContainerFrameItemButton_OnClick fired button="..tostring(button).." alt="..tostring(IsAltKeyDown()).." ctrl="..tostring(IsControlKeyDown()))
	return self.hooks["ContainerFrameItemButton_OnClick"](frame, button, ...)
end

function Postal_Express.SetEnableAltClick(dropdownbutton, arg1, arg2, checked)
	local self = Postal_Express
	Postal.db.profile.Express.EnableAltClick = checked
	if checked then
		if MailFrame:IsVisible() then
			if not self:IsHooked(GameTooltip, "OnTooltipSetItem") then
				self:HookScript(GameTooltip, "OnTooltipSetItem")
			end
		end
	else
		if self:IsHooked(GameTooltip, "OnTooltipSetItem") then
			self:Unhook(GameTooltip, "OnTooltipSetItem")
		end
	end
	-- A hack to get the next button to disable/enable
	local i, j = string.match(dropdownbutton:GetName(), "DropDownList(%d+)Button(%d+)")
	j = tonumber(j) + 1
	if checked then
		_G["DropDownList"..i.."Button"..j]:Enable()
		_G["DropDownList"..i.."Button"..j.."InvisibleButton"]:Hide()
	else
		_G["DropDownList"..i.."Button"..j]:Disable()
		_G["DropDownList"..i.."Button"..j.."InvisibleButton"]:Show()
	end
end

function Postal_Express.SetAutoSend(dropdownbutton, arg1, arg2, checked)
	Postal.db.profile.Express.AutoSend = checked
end

function Postal_Express.SetBulkSend(dropdownbutton, arg1, arg2, checked)
	Postal.db.profile.Express.BulkSend = checked
end

function Postal_Express.ModuleMenu(self, level)
	if not level then return end
	local info = self.info
	wipe(info)
	info.isNotRadio = 1
	if level == 1 + self.levelAdjust then
		local db = Postal.db.profile.Express
		info.keepShownOnClick = 1

		info.text = L["Enable Alt-Click to send mail"]
		info.func = Postal_Express.SetEnableAltClick
		info.checked = db.EnableAltClick
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Auto-Send on Alt-Click"]
		info.func = Postal_Express.SetAutoSend
		info.checked = db.AutoSend
		info.disabled = not Postal.db.profile.Express.EnableAltClick
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Auto-Attach similar items on Control-Click"]
		info.func = Postal_Express.SetBulkSend
		info.checked = db.BulkSend
		info.disabled = nil
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Add multiple item mail tooltips"]
		info.func = Postal.SaveOption
		info.checked = db.MultiItemTooltip
		info.arg1 = "Express"
		info.arg2 = "MultiItemTooltip"
		info.disabled = nil
		UIDropDownMenu_AddButton(info, level)
	end
end
