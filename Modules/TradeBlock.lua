local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_TradeBlock = Postal:NewModule("TradeBlock", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_TradeBlock.description = L["Block incoming trade requests while in a mail session."]

function Postal_TradeBlock:OnEnable()
	local module = self or Postal_TradeBlock
	module:RegisterEvent("MAIL_SHOW")
end

function Postal_TradeBlock:OnDisable()
	local module = self or Postal_TradeBlock
	module:UnregisterAllEvents()
	SetCVar("BlockTrades", 0)
	ClosePetition()
	PetitionFrame:RegisterEvent("PETITION_SHOW")
end

function Postal_TradeBlock:MAIL_SHOW()
	local module = self or Postal_TradeBlock
	PetitionFrame:UnregisterEvent("PETITION_SHOW")
	if IsAddOnLoaded("Lexan") then return end
	if GetCVar("BlockTrades") == "0" then
		module:RegisterEvent("MAIL_CLOSED", "Reset")
		module:RegisterEvent("PLAYER_LEAVING_WORLD", "Reset")
		SetCVar("BlockTrades", 1)
	end
end

function Postal_TradeBlock:Reset()
	local module = self or Postal_TradeBlock
	module:UnregisterEvent("MAIL_CLOSED")
	module:UnregisterEvent("PLAYER_LEAVING_WORLD")
	SetCVar("BlockTrades", 0)
	ClosePetition()
	PetitionFrame:RegisterEvent("PETITION_SHOW")
end
