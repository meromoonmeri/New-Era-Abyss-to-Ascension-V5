require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.CharacterEssentials'
require 'halcyon.GeneralFunctions'

guild_bottom_right_bedroom_ch_3 = {}


function guild_bottom_right_bedroom_ch_3.SetupGround()
	if not SV.Chapter3.DefeatedBoss then
		local zigzagoon = CharacterEssentials.MakeCharactersFromList({
			{'Zigzagoon', 88, 256, Direction.Down}
		})
	end

	GAME:FadeIn(20)

end

function guild_bottom_right_bedroom_ch_3.Zigzagoon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Hé, l'équipe[pause=10]" .. GAME:GetTeamName() .. ",[pause=10]quoi de neuf !")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBR3_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBR3_002']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GBR3_003']))
	GeneralFunctions.EndConversation(chara)
end


return guild_bottom_right_bedroom_ch_3
