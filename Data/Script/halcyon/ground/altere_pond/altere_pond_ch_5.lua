require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

altere_pond_ch_5 = {}

function altere_pond_ch_5.SetupGround()
	--prevent player from going into relic forest before the expedition
	local forestBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
						RogueElements.Rect(904, 256, 8, 88),
						RogueElements.Loc(0, 0), 
						true, 
						"Event_Trigger_1")
																					
	forestBlock:ReloadEvents()

	GAME:GetCurrentGround():AddTempObject(forestBlock)
		
	GAME:FadeIn(20)
end

function altere_pond_ch_5.Relicanth_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Pas de dialogue pour le moment.", "Normal", true, false)
	GeneralFunctions.EndConversation(chara, false)
end 


function altere_pond_ch_5.Event_Trigger_1_Touch(obj, activator)
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")

	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	
	GeneralFunctions.StartPartnerConversation(STRINGS:Format(STRINGS.MapStrings['AP5_004'], zone:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP5_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP5_002']))
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP5_003'], hero:GetDisplayName()))
	GeneralFunctions.EndConversation(partner)

end
