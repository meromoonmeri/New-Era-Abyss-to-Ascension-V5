--[[ FriendAreaUtils.lua — Pattern extrait du mod Friend Area (Someoneelse) ]]--
FriendAreaUtils = {}
function FriendAreaUtils.SpawnAssemblyInArea(map, allowed_species, max_spawns)
    max_spawns = max_spawns or 15
    for i = 1, max_spawns do GROUND:RemoveCharacter("ASSEMBLY_"..tostring(i)) end
    local cnt, si = GAME:GetPlayerAssemblyCount(), 1
    for i = 0, cnt-1 do
        if si > max_spawns then break end
        local p = GAME:GetPlayerAssemblyMember(i)
        local sp = p.BaseForm.Species:lower()
        local fi = p.BaseForm.Form or 0
        local a = allowed_species[sp]
        local ok = a == true or (type(a) == "table" and fi >= a.min_form and fi <= a.max_form)
        if ok then
            local sn = "ASSEMBLY_"..tostring(si)
            GROUND:SpawnerSetSpawn(sn, p); GROUND:SpawnerDoSpawn(sn)
            si = si + 1
        end
    end
end
return FriendAreaUtils