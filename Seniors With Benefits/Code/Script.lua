local stat_scale = const.Scale.Stat

-- Add the Senior label to city
-- Makes iterating and counting seniors easier
local orig_Colonist_AddTolabels = Colonist.AddToLabels
function Colonist:AddToLabels()
  orig_Colonist_AddTolabels(self)
  if self.traits.Senior then 
    self.city:AddToLabel("Senior", self)
  end
end

-- Remove the Senior label from city
-- Makes iterating and counting seniors easier
local orig_Colonist_RemoveFromLabels = Colonist.RemoveFromLabels
function Colonist:RemoveFromLabels()
  orig_Colonist_RemoveFromLabels(self)
  self.city:RemoveFromLabel("Senior", self)
end

function GetSeniorCount(city_or_dome)
  local seniorCount = 0
  if city_or_dome.labels.Senior then
    seniorCount = #(city_or_dome.labels.Senior)
  end
  return seniorCount
end

function GetSeniors(city_or_dome)
  local seniors = {}
  if city_or_dome.labels.Senior then
    seniors = city_or_dome.labels.Senior
  end
  return seniors
end

function GetSeniorsWithTraits(dome, traits)
  local seniorsWithTraitCount = 0
  for _, colonist in pairs(dome.labels.Senior or empty_table) do
    for key, value in pairs(traits) do
      if colonist.traits[value] then
        seniorsWithTraitCount = seniorsWithTraitCount + 1
      end
    end
  end
  return seniorsWithTraitCount
end

function isHappy(colonist)
  local high_stat_threshold = g_Consts.HighStatLevel
  return high_stat_threshold <= colonist.stat_morale and high_stat_threshold <= colonist.stat_health and high_stat_threshold <= colonist.stat_sanity and high_stat_threshold <= colonist.stat_comfort
end

function isUnhappy(colonist) 
  local low_stat_threshold = g_Consts.LowStatLevel
  return low_stat_threshold > colonist.stat_morale or low_stat_threshold > colonist.stat_health or low_stat_threshold > colonist.stat_sanity or low_stat_threshold > colonist.stat_comfort
end

-- Seniors bring out the best in Children
function GetRareTraitChance(unit)
  local city = unit and unit.city or UICity
  local rare_chance_mod = 0
  if city and city:IsTechResearched("GeneSelection") then
    local def = TechDef.GeneSelection
    rare_chance_mod = def.param1
  end
  local dome = unit.dome
  if dome then
  	rare_chance_mod = rare_chance_mod + Min(GetSeniorCount(dome), 50)
  end
  return rare_chance_mod
end

-- Seniors share cautionary tales
local flawRemovedByPerks = { Coward={'Composed', 'Survivor'}, Renegade={'Empath', 'Saint'}, Melancholic={'Enthusiast'}, Glutton={'Fit'}, Gambler={'Gamer'}, Idiot={'Genius'}, Hypochondriac={'Nerd'}, Loner={'Party Animal'}, Alcoholic={'Religious'}, Whiner={'Rugged'}, Lazy={'Workaholic'}} 
local chanceMultipliersPerAge = { Youth=4, Adult=2, ['Middle Aged']=1}
local maxChancePerAge = { Youth=20, Adult=10, ['Middle Aged']=5}
function shareCautionaryTales(colonist)
  local dome = colonist.dome
  local traits = colonist.traits
  if not traits.Child and not traits.Senior and dome and GetSeniorCount(dome) > 0 then
    local ageTrait = colonist.age_trait
    local chanceMultiplier = chanceMultipliersPerAge[ageTrait]
    local maxChance = maxChancePerAge[ageTrait]
    for negativeTraitId, _ in pairs(traits) do
        local perks = flawRemovedByPerks[negativeTraitId]
        if perks then
          local seniorsWithTrait = GetSeniorsWithTraits(dome, perks)
          local chance = Min(maxChance, MulDivRound(seniorsWithTrait, chanceMultiplier, 1))
          if colonist:Random(100) <= chance then
            colonist.RemoveTrait(negativeTraitId)
            colonist:ChangeComfort(10 * stat_scale, "Senior citizen talked some sense into me (%s was removed) " .. negativeTraitId)
            dome.tremualin_lifetime = (dome.tremualin_lifetime or 0) + 1
            if not dome.tremualin_removed_traits_log then
              dome.tremualin_removed_traits_log = {}
            end
            dome.tremualin_removed_traits_log[negativeTraitId] = (dome.tremualin_removed_traits_log[negativeTraitId] or 0) + 1
          end
        end
    end
  end
end

-- How are our seniors doing across the city?
-- bad if at least 10% of senior are unhappy, good if at least 95% of seniors are good, otherwise neutral
function seniorsWellbeing(city)
  local result = 'neutral'
  local totalSeniors = GetSeniorCount(city)
  if totalSeniors > 0 then
    local happySeniors = 0
    local unhappySeniors = 0
    for _, senior in pairs(GetSeniors(city)) do
      if isHappy(senior) then
        happySeniors = happySeniors + 1
      elseif isUnhappy(senior) then
        unhappySeniors = unhappySeniors + 1
      end
    end
    if MulDivRound(unhappySeniors, 100, totalSeniors) > 0.1 then 
      result = 'bad'
    elseif MulDivRound(happySeniors, 100, totalSeniors) > 0.95 then
      result = 'good'
    end
  end
  return result
end

-- Seniors help other seniors
function seniorsHelpOtherSeniors(colonist)
  local dome = colonist.dome
  local medicals = dome.labels.MedicalBuilding or empty_table
  if #medicals > 0 then 
    if colonist.traits.Senior and GetSeniorCount(dome) >= 10 then
      colonist:ChangeSanity(5 * stat_scale, "Seniors care for other seniors ") 
      colonist:ChangeHealth(5 * stat_scale, "Seniors care for other seniors ")
    end
  end
end

-- Seniors become role models
function seniorsBecomeRoleModels(colonist)
  local performanceBonus = 0
  local traits = colonist.traits
  local dome = colonist.dome
  if dome and traits.Child or traits.Youth or traits.Adult then 
    if traits.Child then
      local role_model_traits = {}
      -- Added flaws to reduce the effect of Hive Mind
      local role_model_flaws = {}
      local trait_defs = TraitPresets
      for _, unit in ipairs(GetSeniors(dome)) do
        for trait_id in pairs(unit.traits) do
          if trait_id ~= "none" then
            local trait_def = trait_defs[trait_id]
            local cat = trait_def and trait_def.group
            if cat == "Positive" or cat == "Specialization" then
              role_model_traits[trait_id] = true
            elseif cat == "Negative" then
              role_model_flaws[trait_id] = true
            end
          end
        end
      end
      performanceBonus = Max(0, table.count(role_model_traits) - table.count(role_model_flaws))
    else 
      local shared_traits = {}
      local trait_defs = TraitPresets
      for _, unit in ipairs(GetSeniors(colonist.dome)) do
        for trait_id in pairs(traits) do
          if trait_id ~= "none" and traits[trait_id] then
              shared_traits[trait_id] = true
          end
        end
      end
      -- bonus performance based on the shared traits of their role model
      performanceBonus = Max(0, table.count(shared_traits))
      if traits.Youth then
        performanceBonus = performanceBonus * 2
      end
    end
  end
  colonist:SetModifier("performance", "SeniorRoleModels", performanceBonus, 0, "<green>Inspired by senior role models +".. performanceBonus .. "</color>")
end

local orig_Colonist_DailyUpdate = Colonist.DailyUpdate
function Colonist:DailyUpdate()
  if self.traits.Tourist then 
    -- tourists literally live in their own world, they don't care about Martian affairs
  else
    seniorsBecomeRoleModels(self)
    seniorsHelpOtherSeniors(self)
    shareCautionaryTales(self)
  end
  orig_Colonist_DailyUpdate(self)
end

local seniorWellbeingNegativeMoraleChangePerAge = { Youth=10, Adult=20, ['Middle Aged']=30}
local seniorWellbeingPositiveMoraleChangePerAge = { Youth=5, Adult=5, ['Middle Aged']=15}
local orig_Colonist_UpdateMorale = Colonist.UpdateMorale
-- Senior well being matters, morale update
function Colonist:UpdateMorale()
  orig_Colonist_UpdateMorale(self)
  if self:IsDead() then
    return
  end
  local seniorsWellbeingResult = seniorsWellbeing(self.city)
  if self.traits.Renegade or self.traits.Child or self.traits.Senior then
      -- Renegades don't have morale you silly goose
      -- Children don't keep up with the news
      -- Seniors are already happy/unhappy 
  else 
    if seniorsWellbeingResult == "good" then
      local amount = seniorWellbeingPositiveMoraleChangePerAge[self.age_trait]
      self.stat_morale = self.stat_morale + amount * stat_scale
    elseif seniorsWellbeingResult == "bad" then 
      local amount = seniorWellbeingNegativeMoraleChangePerAge[self.age_trait]
      self.stat_morale = self.stat_morale - amount * stat_scale
    end
    Msg("MoraleChanged", self)
  end
end


-- Senior well being matters, UI update
local orig_Colonist_UiStatUpdate = Colonist.UIStatUpdate
function Colonist:UIStatUpdate(win, stat)
  orig_Colonist_UiStatUpdate(self, win, stat)
  local orig_win_GetRolloverText = win.GetRolloverText
  win.GetRolloverText = function(self)
    local texts = orig_win_GetRolloverText(self)
    local colonist = self.context
    if colonist.traits.Renegade or colonist.traits.Child or colonist.traits.Senior then 
      -- Renegades don't have morale you silly goose
      -- Children don't keep up with the news
      -- Seniors are already happy/unhappy
    elseif stat == "Morale" then
      local seniorsWellbeingResult = seniorsWellbeing(colonist.city)
      if seniorsWellbeingResult ~= "neutral" then
        texts = texts .. "\n" 
        if seniorsWellbeingResult == "good" then
          local amount = seniorWellbeingPositiveMoraleChangePerAge[colonist.age_trait]
          local clr = (TLookupTag("<green>"))
          texts = texts .. (T({
                  6936,
                  "<clr><reason></color>",
                  reason = Untranslated("Most senior citizens seem to be happy +" .. amount),
                  clr = clr,
                }))
        elseif seniorsWellbeingResult == "bad" then
          local amount = seniorWellbeingNegativeMoraleChangePerAge[colonist.age_trait]
          local clr = (TLookupTag("<red>"))
          texts = texts .. (T({
                  6936,
                  "<clr><reason></color>",
                  reason = Untranslated("Too many senior citizens are miserable -" .. amount),
                  clr = clr,
                }))
        end
      end
    end
    return texts .. "\n"
  end
end

local function RemoveXTemplateSections(list, name)
  local idx = table.find(list, name, true)
  if idx then
    list[idx]:delete()
    table.remove(list, idx)
  end
end

-- A button that turns a residence into a seniors only residence
function OnMsg.ClassesPostprocess()
  local template = XTemplates.sectionResidence
  RemoveXTemplateSections(template, "Tremualin_SeniorsAllowed")
  local seniorsInfo = PlaceObj("XTemplateTemplate", {
    "Tremualin_SeniorsAllowed", true,
    "__template", "InfopanelSection",
    "__context_of_kind", "Residence",
    "OnContextUpdate", function(self, context)
      if context.exclusive_trait == "Senior" then 
        self:SetRolloverText("Only seniors are allowed on this residence")
        self:SetTitle("Only seniors allowed")
        self:SetIcon("UI/Icons/Upgrades/rejuvenation_treatment_01.tga")
      elseif context.exclusive_trait then
        self:SetVisible(false)
      else
        self:SetRolloverText("Everyone is allowed on this residence")
        self:SetTitle("Everyone allowed")
        self:SetIcon("UI/Icons/Upgrades/rejuvenation_treatment_02.tga")
      end
    end,
  },
  {
    PlaceObj("XTemplateFunc", {
      "name", "OnActivate(self, context)",
      "parent", function(self)
        return self.parent
      end,
      "func", function(self, context)
        -- we remove the trait if present, and reduce capacity
        if context.exclusive_trait == "Senior" then
          context.capacity = context.capacity - context.seniors_extra_capacity
          context.exclusive_trait = false
          -- since we changed capacity, we need to ensure there is room for everyone
          for i = #context.colonists, 1, -1 do
            if i>=context.capacity then
              local colonist = context.colonists[i]
              context:RemoveResident(colonist)
            end
          end
          context:CheckHomeForHomeless()
        elseif context.exclusive_trait then
          -- do nothing
        else
          context.exclusive_trait = "Senior"
          -- increase capacity by 50% to compete with senior residences
          context.seniors_extra_capacity = context.capacity * 0.5
          context.capacity = context.capacity + context.seniors_extra_capacity
          -- first we process all colonists within the residence and kick out the youngsters
          for i = #context.colonists, 1, -1 do
            local colonist = context.colonists[i]
            if IsValid(colonist) then
              colonist:UpdateResidence()
            end
          end
          -- then we process all colonists within the dome to make sure all seniors move into the residence
          -- we will process some colonists twice but I'm too lazy to care
          for i = #(context.parent_dome.labels.Colonist or empty_table), 1, -1 do
            local colonist = context.parent_dome.labels.Colonist[i]
            if IsValid(colonist) then
              colonist:UpdateResidence()
            end
          end 
        end
        -- If you modified a value then use this, if not remove
        ObjModified(context)
        RebuildInfopanel(context)
        ---
      end
    }),
  })

  table.insert(template, #template, seniorsInfo)
end

local orig_Dome_Init = Dome.Init
function Dome:Init()
  orig_Dome_Init(self)
  self.tremualin_removed_traits_log = {}
  self.tremualin_lifetime = 0
end

function Dome:GetUISectionTremualinSeniorsLifetimeRollover()
  local items = {}
  for trait_id, val in sorted_pairs(self.tremualin_removed_traits_log or empty_table) do
    local trait = TraitPresets[trait_id]
    items[#items + 1] = (T({
      432,
      "<trait_name><right><value>",
      trait_name = trait.display_name,
      value = val
    }))
  end
  return next(items) and table.concat(items, "<newline><left>") or Untranslated("Information about the traits removed by Seniors")
end

function Dome:GetTremualinSeniorsLifetime()
  return self.tremualin_lifetime or 0
end

-- A panel that shows how many conversions have happened in the dome
function OnMsg.ClassesPostprocess()
  local template = XTemplates.sectionDome
  RemoveXTemplateSections(template, "Tremualin_SeniorsLifetime")
  local tremualin_SeniorsLifetime = PlaceObj("XTemplateTemplate", {
    "Tremualin_SeniorsLifetime", true,
    "__context_of_kind", "Dome",
    "__template", "InfopanelSection",
    "RolloverText", Untranslated("<UISectionTremualinSeniorsLifetimeRollover>"),
    "Title", Untranslated("Traits removed by seniors"),
    "Icon", "UI/Icons/Sections/facility.tga"
  }, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "InfopanelText",
      "Text",
      Untranslated("Lifetime<right><TremualinSeniorsLifetime>")
    })
  })

  table.insert(template, #template, tremualin_SeniorsLifetime)
end