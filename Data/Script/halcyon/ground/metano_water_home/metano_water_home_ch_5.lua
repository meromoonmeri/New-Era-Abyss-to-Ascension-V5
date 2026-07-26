require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_water_home_ch_5 = {}

function metano_water_home_ch_5.SetupGround()
	

	local floatzel, quagsire  = 
		CharacterEssentials.MakeCharactersFromList({
			{'Floatzel', 232, 120, Direction.Down},
			{'Quagsire', 232, 168, Direction.Up}
		})
	
	GAME:FadeIn(20)
end


function metano_water_home_ch_5.Floatzel_Action(chara, activator)

end 

function metano_water_home_ch_5.Quagsire_Action(chara, activator)

end 

--Maris explains to Tweed why his plan wasn't going to work, Tweed understands but then doubles down and says he just needs a better scheme. Maris groans.
function metano_water_home_ch_5.Floatzel_Quagsire_Conversation(chara, activator)

end