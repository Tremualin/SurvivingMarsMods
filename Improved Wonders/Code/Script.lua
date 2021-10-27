local configuration = Tremualin.Configuration
configuration.ProjectMorphiousPositiveTraitChance = 4
configuration.ProjectMorphiousMaxTraits = 7

local function SetConsts(id, value)
    Consts[id] = value
    g_Consts[id] = value
end

function OnMsg.ClassesPostprocess()
    -- set the original ProjectMorpheus chance to -1 so only my code adds traits
    SetConsts("ProjectMorphiousPositiveTraitChance", -1)

    -- Project Morpheus only adds Traits when colonists
    local Tremualin_Orig_Colonist_Rest = Colonist.Rest
    function Colonist:Rest()
        local orig = Tremualin_Orig_Colonist_Rest(self)
        local wonder = self.city.labels.ProjectMorpheus or empty_table
        if not self.traits.Child and #wonder > 0 and wonder[1].working then
            local count = 0
            for id, _ in pairs(self.traits) do
                local trait = TraitPresets[id]
                -- only counts positive traits
                if trait and trait.category and trait.category == "Positive" then
                    count = count + 1
                end -- if trait
            end -- for id, _
            if count < configuration.ProjectMorphiousMaxTraits and self:Random(100) <= configuration.ProjectMorphiousPositiveTraitChance then
                -- add positive trait
                wonder[1]:AddTrait(self)
            end -- if count < 5
        end -- if not selfs.traits.Child
        return orig
    end -- function Colonist:Rest
end -- function OnMsg.ClassesPostprocess()
