local gamingUpgradeId = "Tremualin_HomeGamingUpgrade"

local function AddUpgrade(obj, id, cost)
	obj.upgrade2_id = gamingUpgradeId
	obj.upgrade2_description = Untranslated("Adds a 40% + WorkshopBonus chance to automatically satisfy the gaming interest. Double chances if the dome has a NetworkNode")
	obj.upgrade2_display_name = Untranslated("Home Gaming")
	obj.upgrade2_icon = "UI/Icons/Upgrades/factory_ai_01.tga"
	obj.upgrade2_upgrade_cost_Electronics = cost
end

local function AddBuilding(id, obj, obj_ct, cls)
	-- If the template doesn't have the prop, check the class obj
	local template_id = obj.template_class
	if template_id == "" then
		template_id = obj.template_name
	end

	if obj.capacity or obj_ct.capacity then 
		local cost = (obj.capacity or obj_ct.capacity) * 1000/4 
		AddUpgrade(obj, id, cost)
		AddUpgrade(obj_ct, id, cost)
	end
end

function OnMsg.ModsReloaded()
	local g_Classes = g_Classes

	local ct = ClassTemplates.Building
	local BuildingTemplates = BuildingTemplates

	for id, buildingTemplate in pairs(BuildingTemplates) do
		if buildingTemplate.children_only then
			-- no, children don't play video games
		elseif buildingTemplate.label2 == "Residence" then
			AddBuilding(id, buildingTemplate, ct[id], g_Classes[id])
		end
	end
end

function OnMsg.TechResearched(tech_id)
	if tech_id == "CreativeRealities" then
		UnlockUpgrade("Tremualin_HomeGamingUpgrade")
	end
end

function StartupCode()
	local unlocked_upgrades = UICity.unlocked_upgrades
	if IsTechResearched("CreativeRealities") then
		unlocked_upgrades["Tremualin_HomeGamingUpgrade"]=true
	end	
end

OnMsg.LoadGame = StartupCode

local orig_Colonist_DailyUpdate = Colonist.DailyUpdate
function Colonist:DailyUpdate()
	orig_Colonist_DailyUpdate(self)
	local residence = self.residence
	local city = self.city
	if residence and residence.upgrades_built[gamingUpgradeId]
		and self.daily_interest == "interestGaming" then
		local chance = 40 + city:GetWorkshopWorkersPercent()
		for _, spire in ipairs(self.dome.labels.Spire or empty_table) do
		    if spire.working and spire:IsKindOf("NetworkNode") then
		    	chance = chance * 2
		    	break
		    end
		end
		if self:Random(100) < chance then
			self.daily_interest = ""
			if self.traits.Gamer then
			  local trait_gamer = TraitPresets.Gamer
			  self:ChangeSanity(trait_gamer.param * const.Scale.Stat, trait_gamer.id)
			end
			local comfort_threshold = residence:GetEffectiveServiceComfort()
		  	if comfort_threshold > self.stat_comfort then
			    local comfort_increase = residence.comfort_increase
				self:ChangeComfort(comfort_increase, "<green>Played games in my home gaming system </color>")
		  	end
	  	end
	end 
end
