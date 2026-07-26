--[[
    metano_town_legend.lua
    Le stand de Grodoudou — vente des zones de recrutement legendaires.

    ------------------------------------------------------------------
    SUR QUOI CE CODE S'APPUIE (aucune mecanique nouvelle)
    ------------------------------------------------------------------
    La boutique reprend exactement le squelette de metano_town.Shop_Action
    (Kecleon, init.lua:717) : boucle `while state > -1`, UI:BeginChoiceMenu,
    UI:ChoiceMenuYesNo, GAME:GetPlayerMoney / GAME:RemoveFromPlayerMoney,
    SOUND:PlayBattleSE("DUN_Money"). Seul le catalogue change : on vend des
    acces a des lieux, pas des objets, donc UI:ShopMenu (qui attend des
    InvItem) ne convient pas et on utilise UI:BeginChoiceMenu.

    Le flash blanc de validation reprend le motif exact de
    COMMON.BossTransition (common.lua:513-535), verifie present :
        RogueEssence.Content.FlashEmitter()
        emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
        GROUND:PlayVFX(emitter, center.X, center.Y)
        SOUND:PlayBattleSE("EVT_Battle_Flash")
    "White" est un BG du jeu de base, deja utilise par 20 sites d'appel du
    projet. On passe par BossFX.Flash, qui encapsule ce meme motif.

    Le voyage vers la zone reprend GAME:EnterDungeon, comme le menu de
    destination de la ville (init.lua:457).
]]--

require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.LegendZones'
require 'halcyon.BossFX'

local metano_town_legend = {}

--------------------------------------------------------------------
-- Mise en scene
--------------------------------------------------------------------

--Grodoudou se tourne vers l'equipe, heros et partenaire se tournent vers elle.
local function FaceUp(chara, hero, partner)
    chara.IsInteracting = true
    if partner ~= nil then partner.IsInteracting = true end
    GROUND:CharSetAnim(hero, 'None', true)
    if partner ~= nil then GROUND:CharSetAnim(partner, 'None', true) end
    GROUND:CharSetAnim(chara, 'None', true)
    GROUND:CharTurnToChar(hero, chara)
    if partner ~= nil then
        TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
    end
    UI:SetSpeaker(chara)
end

--Le flash blanc de validation d'achat.
--Grodoudou frappe dans ses mains, l'ecran blanchit, et le nom du lieu
--"existe" desormais. C'est la seule chose que l'achat produit : une
--connaissance, pas une capture.
local function PurchaseFlash(chara)
    local center = GAME:GetCameraCenter()
    GROUND:CharSetEmote(chara, "glowing", 1)
    SOUND:PlayBattleSE("DUN_Money")
    GAME:WaitFrames(14)
    -- BossFX.Flash encapsule FlashEmitter + BGAnimData("White", 0)
    -- + SOUND:PlayBattleSE("EVT_Battle_Flash").
    BossFX.Flash(center.X, center.Y, 2, 6, 26)
    GAME:WaitFrames(30)
    GROUND:CharSetEmote(chara, "", 0)
end

--------------------------------------------------------------------
-- Sous-menus
--------------------------------------------------------------------

--Achat d'une zone. Renvoie true si une vente a eu lieu.
local function BuyMenu(chara)
    local offers = LegendZones.GetAvailable()

    if #offers == 0 then
        UI:SetSpeakerEmotion("Sad")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Nothing_001']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Nothing_002']))
        UI:SetSpeakerEmotion("Normal")
        return false
    end

    local choices = {}
    for _, e in ipairs(offers) do
        table.insert(choices, STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Entry'],
            LegendZones.ZoneName(e), STRINGS:FormatKey("MONEY_AMOUNT", e.price)))
    end
    table.insert(choices, STRINGS:FormatKey("MENU_EXIT"))

    UI:BeginChoiceMenu(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Buy_Prompt']),
                       choices, 1, #choices)
    UI:WaitForChoice()
    local pick = UI:ChoiceResult()

    if pick > #offers then return false end
    local entry = offers[pick]

    -- Le boniment propre a cette zone, puis ce qu'on y verrait.
    UI:SetSpeakerEmotion("Inspired")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[entry.blurb]))
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[entry.sight]))

    -- Rappel explicite : on achete un chemin, pas un Pokemon.
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Disclaimer'],
        LegendZones.SpeciesName(entry)))

    UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Confirm'],
        LegendZones.ZoneName(entry), STRINGS:FormatKey("MONEY_AMOUNT", entry.price)), false)
    UI:WaitForChoice()
    if not UI:ChoiceResult() then
        UI:SetSpeakerEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Declined']))
        return false
    end

    if entry.price > GAME:GetPlayerMoney() then
        UI:SetSpeakerEmotion("Worried")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_No_Money']))
        UI:SetSpeakerEmotion("Normal")
        return false
    end

    GAME:RemoveFromPlayerMoney(entry.price)
    LegendZones.SetPurchased(entry.key)

    -- === CINEMATIQUE D'ACHAT : FLASH BLANC ===
    PurchaseFlash(chara)

    -- Retour a la boutique, confirmation de la zone debloquee.
    UI:SetSpeaker(chara)
    UI:SetSpeakerEmotion("Joyous")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Bought_001'],
        LegendZones.ZoneName(entry)))
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Bought_002']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Bought_003'],
        LegendZones.SpeciesName(entry)))
    return true
end

--Depart vers une zone deja achetee.
local function TravelMenu(chara)
    local owned = LegendZones.GetOwned()

    if #owned == 0 then
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_No_Zones']))
        return false
    end

    local choices = {}
    for _, e in ipairs(owned) do
        local label = LegendZones.ZoneName(e)
        if LegendZones.IsDefeated(e.key) then
            -- Deja vaincu une fois : on le signale sans fermer la porte,
            -- le joueur peut vouloir y retourner (recrutement rate, etc.).
            label = label .. STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Cleared_Tag'])
        end
        table.insert(choices, label)
    end
    table.insert(choices, STRINGS:FormatKey("MENU_EXIT"))

    UI:BeginChoiceMenu(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Travel_Prompt']),
                       choices, 1, #choices)
    UI:WaitForChoice()
    local pick = UI:ChoiceResult()
    if pick > #owned then return false end

    local entry = owned[pick]
    UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Travel_Confirm'],
        LegendZones.ZoneName(entry)), false)
    UI:WaitForChoice()
    if not UI:ChoiceResult() then return false end

    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Travel_Go']))
    UI:SetSpeakerEmotion("Normal")

    GeneralFunctions.EndConversation(CH('Teammate1'))
    SV.partner.Spawn = "Default"
    GAME:FadeOut(false, 30)
    -- Meme appel que le menu de destination de la ville (init.lua:457).
    GAME:EnterDungeon(entry.zone, entry.segment, 0, 0,
        RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return true
end

--Explications. Grodoudou dit clairement la regle du jeu.
local function InfoMenu()
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Info_001']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Info_002']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Info_003']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Info_004']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Info_005']))
end

--------------------------------------------------------------------
-- Point d'entree
--------------------------------------------------------------------

function metano_town_legend.Legend_Merchant_Action(chara, activator)
    DEBUG.EnableDbgCoro()
    LegendZones.EnsureSV()

    local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    local merchant = CH('Legend_Merchant')
    if merchant == nil then return end

    FaceUp(merchant, hero, partner)

    -- Premiere rencontre : Grodoudou se presente. Une seule fois.
    if not SV.LegendZones.MetMerchant then
        SV.LegendZones.MetMerchant = true
        UI:SetSpeakerEmotion("Joyous")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Meet_001']))
        UI:SetSpeakerEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Meet_002']))
        UI:SetSpeakerEmotion("Inspired")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Meet_003']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Meet_004']))
        UI:SetSpeakerEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Meet_005']))
    end

    local state = 0
    local repeated = false

    while state > -1 do
        if state == 0 then
            local msg = STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Intro'])
            if repeated then
                msg = STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Intro_Return'])
            end
            repeated = true

            local choices = {
                STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Option_Buy']),
                STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Option_Travel']),
                STRINGS:FormatKey("MENU_INFO"),
                STRINGS:FormatKey("MENU_EXIT")
            }

            UI:BeginChoiceMenu(msg, choices, 1, #choices)
            UI:WaitForChoice()
            local result = UI:ChoiceResult()

            if result == 1 then
                state = 1
            elseif result == 2 then
                state = 2
            elseif result == 3 then
                InfoMenu()
            else
                UI:SetSpeakerEmotion("Happy")
                UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['LZ_Shop_Goodbye']))
                UI:SetSpeakerEmotion("Normal")
                state = -1
            end

        elseif state == 1 then
            BuyMenu(merchant)
            state = 0

        elseif state == 2 then
            -- Si le voyage part, EnterDungeon a deja pris la main.
            if TravelMenu(merchant) then return end
            state = 0
        end
    end

    GeneralFunctions.EndConversation(partner)
    merchant.IsInteracting = false
end

return metano_town_legend
