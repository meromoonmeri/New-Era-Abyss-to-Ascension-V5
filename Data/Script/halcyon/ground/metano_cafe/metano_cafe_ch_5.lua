require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_cafe_ch_5 = {}

function metano_cafe_ch_5.SetupGround()
	local gulpin, lickitung, cleffa, aggron = 
		CharacterEssentials.MakeCharactersFromList({
			{'Gulpin', 'Cafe_Table_2'},
			{'Lickitung', 'Cafe_Table_1'},
			{'Cleffa', 'Cafe_Table_13'},
			{'Aggron', 'Cafe_Table_15'}
		})
	
		
	GAME:FadeIn(20)
end


function metano_cafe_ch_5.Lickitung_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "C'était gentil de la part de " .. CharacterEssentials.GetCharacterName("Shuckle") .. " d'offrir des boissons aujourd'hui,[pause=10] mais...")
	--GROUND:CharSetEmote(chara, "sweating", 1)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF5_001']))
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_5.Gulpin_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Une boisson offerte par " .. CharacterEssentials.GetCharacterName("Shuckle") .. "...[pause=0] C'est un rêve qui devient réalité !", "Inspired")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF5_002']))
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF5_003']))
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_5.Cleffa_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Bonjour !")
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_5.Aggron_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Bonjour !")
	GeneralFunctions.EndConversation(chara)
end 
--[[
	GeneralFunctions.StartConversation(chara, "Vous partez en expédition aujourd'hui,[pause=10] n'est-ce pas ?[pause=0] Vous devriez prendre quelques boissons de " .. CharacterEssentials.GetCharacterName("Shuckle") .. " avec vous.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF5_004']))
	GeneralFunctions.EndConversation(chara)
	
	GeneralFunctions.StartConversation(chara, "Emportez autant de boissons de " .. CharacterEssentials.GetCharacterName("Shuckle") .. " que possible pendant votre expédition...")
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MCF5_005']))
	GeneralFunctions.EndConversation(chara)
]]--

