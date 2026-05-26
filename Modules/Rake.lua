local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_Rake = Postal:NewModule("Rake", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_Rake.description = L["Prints the amount of money collected during a mail session."]

local money
local flag = false

function Postal_Rake:OnEnable()
	local module = self or Postal_Rake
	module:RegisterEvent("MAIL_SHOW")
end

function Postal_Rake:OnDisable()
	local module = self or Postal_Rake
	module:UnregisterAllEvents()
end

function Postal_Rake:MAIL_SHOW()
	local module = self or Postal_Rake
	if not flag then
		money = GetMoney()
		module:RegisterEvent("MAIL_CLOSED")
		flag = true
	end
end

function Postal_Rake:MAIL_CLOSED()
	local module = self or Postal_Rake
	flag = false
	module:UnregisterEvent("MAIL_CLOSED")
	money = GetMoney() - money
	if money > 0 then
		Postal:Print(L["Collected"].." "..Postal:GetMoneyString(money))
	end
end
