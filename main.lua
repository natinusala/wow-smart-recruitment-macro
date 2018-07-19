RecrutementEuphorie = LibStub("AceAddon-3.0"):NewAddon("RecrutementEuphorie", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceTimer-3.0");
local AceGUI = LibStub("AceGUI-3.0");

function RecrutementEuphorie:IsAuthority()
	return UnitName("player") == "Putrebifle";
end

RecrutementEuphorie_MACRO_NAME = "Recrut. Euphorïe";

RecrutementEuphorie_UPDATE_BROADCAST_PAYLOAD_PREFIX = "RE_U_PAYLOAD";
RecrutementEuphorie_REQUEST_BROADCAST_PAYLOAD_PREFIX = "RE_R_PAYLOAD";

function RecrutementEuphorie:SendRequest() 
	RecrutementEuphorie:SendCommMessage(RecrutementEuphorie_REQUEST_BROADCAST_PAYLOAD_PREFIX, "", "GUILD");
end

function RecrutementEuphorie:PLAYER_ENTERING_WORLD()
	if GetMacroIndexByName(RecrutementEuphorie_MACRO_NAME) == 0 then
		macroId= CreateMacro(RecrutementEuphorie_MACRO_NAME, "ability_warrior_rallyingcry", "/run RecrutementEuphorie:MacroClicked();", nil)
		if macroId == 0 then
			RecrutementEuphorie:Print("Erreur lors de l'ajout de la macro !");
		else
			RecrutementEuphorie:Print("Macro de recrutement ajoutée ; ID:" .. macroId);
		end
	end
	
	RecrutementEuphorie:SendUpdate(false);
	
	if not RecrutementEuphorie:IsAuthority() then
		RecrutementEuphorie:ScheduleTimer("SendRequest", 5);
	end
end

function RecrutementEuphorie:SerializePayload()
	return RecrutementEuphoriePayloadRevision .. "\n" .. RecrutementEuphoriePayloadMessage;
end

function RecrutementEuphorie:DeserializePayload(message)
	revision, message = strsplit("\n", message);
	return revision, message;
end

function RecrutementEuphorie:On_REUPDATE()
	if RecrutementEuphorie:IsAuthority() then
		local frame = AceGUI:Create("Frame");
		frame:SetTitle("Recrutement Euphorïe");
		frame:SetLayout("List");
		
		local editbox = AceGUI:Create("MultiLineEditBox")
		editbox:SetLabel("Message :");
		editbox:SetMaxLetters(255);
		if not (RecrutementEuphoriePayloadMessage == nil) then 
			editbox:SetText(RecrutementEuphoriePayloadMessage);
		end
		editbox:SetNumLines(5);
		editbox:SetWidth(500);
		
		editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
												if RecrutementEuphoriePayloadRevision == nil then RecrutementEuphoriePayloadRevision = 0; end
												RecrutementEuphoriePayloadRevision = RecrutementEuphoriePayloadRevision + 1;
												RecrutementEuphoriePayloadMessage = text;
												RecrutementEuphorie:Print("Message mis à jour (nouvelle révision : " .. RecrutementEuphoriePayloadRevision .. ")");
												RecrutementEuphorie:SendUpdate(true); 
		end);
		
		frame:AddChild(editbox);
		
		local button = AceGUI:Create("Button");
		button:SetText("Renvoyer le message actuel à tout le monde");
		button:SetWidth(500);
		
		button:SetCallback("OnClick", function() RecrutementEuphorie:SendUpdate(true); end);
		
		frame:AddChild(button);
	end
end

function RecrutementEuphorie:SendUpdate(notify)
	if RecrutementEuphoriePayloadRevision == nil then return; end
	RecrutementEuphorie:SendCommMessage(RecrutementEuphorie_UPDATE_BROADCAST_PAYLOAD_PREFIX, RecrutementEuphorie:SerializePayload(), "GUILD");
	if notify then
		RecrutementEuphorie:Print("Message envoyé.");
	end
end

function RecrutementEuphorie:On_REREVISION()
	if RecrutementEuphoriePayloadRevision == nil or RecrutementEuphoriePayloadRevision == 0 then
		RecrutementEuphorie:Print("Aucun message de recrutement enregistré, veuillez patienter qu'un joueur qui le possède se connecte.");
	else
		RecrutementEuphorie:Print("Révision du message de recrutement : " .. RecrutementEuphoriePayloadRevision);
	end
end

function RecrutementEuphorie:On_REMESSAGE()
	if RecrutementEuphoriePayloadRevision == nil or RecrutementEuphoriePayloadRevision == 0 then
		RecrutementEuphorie:Print("Aucun message de recrutement enregistré, veuillez patienter qu'un joueur qui le possède se connecte.");
	else
		RecrutementEuphorie:Print("Message de recrutement : " .. RecrutementEuphoriePayloadMessage);
		RecrutementEuphorie:Print("Message de recrutement : " .. RecrutementEuphoriePayloadMessage);
	end
end


function RecrutementEuphorie:MacroClicked()
	if RecrutementEuphoriePayloadMessage == "" or RecrutementEuphoriePayloadMessage == nil then
		RecrutementEuphorie:Print("Aucun message de recrutement enregistré, veuillez patienter qu'un joueur qui le possède se connecte.");
	else
		SendChatMessage(RecrutementEuphoriePayloadMessage, "CHANNEL", nil, "2");
	end
end

function RecrutementEuphorie:On_REQUEST_BROADCAST_PAYLOAD(prefix, message, distribution, sender)
	RecrutementEuphorie:SendUpdate(false);
end

function RecrutementEuphorie:On_UPDATE_BROADCAST_PAYLOAD(prefix, message, distribution, sender)
	if RecrutementEuphorie:IsAuthority() then return; end
	revision, message = RecrutementEuphorie:DeserializePayload(message);
		
	if (RecrutementEuphoriePayloadRevision == nil or tonumber(revision) > tonumber(RecrutementEuphoriePayloadRevision)) then
		RecrutementEuphoriePayloadRevision = revision;
		RecrutementEuphoriePayloadMessage = message;
		RecrutementEuphorie:Print("Message de recrutement mis à jour (révision " .. revision .. ")");
	end
end

function RecrutementEuphorie_Load()
	RecrutementEuphorie:RegisterEvent("PLAYER_ENTERING_WORLD");
	
	RecrutementEuphorie:RegisterComm(RecrutementEuphorie_UPDATE_BROADCAST_PAYLOAD_PREFIX, "On_UPDATE_BROADCAST_PAYLOAD");
	RecrutementEuphorie:RegisterComm(RecrutementEuphorie_REQUEST_BROADCAST_PAYLOAD_PREFIX, "On_REQUEST_BROADCAST_PAYLOAD");
	
	RecrutementEuphorie:RegisterChatCommand("rerevision", "On_REREVISION");
	RecrutementEuphorie:RegisterChatCommand("reupdate", "On_REUPDATE");
	RecrutementEuphorie:RegisterChatCommand("remessage", "On_REMESSAGE");
end

RecrutementEuphorie_Load();
