local TemporarilyModifyMorale = Tremualin.Functions.TemporarilyModifyMorale

local protests_text = {
    "Bring back the McRib",
    "I really really want a haircut",
    "Monorail! Monorail! Monorail! Monorail!",
    "Hustle culture is a lie, no more overtime",
    "Another day, another sanity breakdown",
    "Stop sending people to murder domes",
    "We live inside a simulation",
    "I'm just here for the violence",
    "I actually wanted to colonize the Moon",
    "I don't want to live on this planet anymore",
    "We are being coerced into making babies",
    "Soylent Green is people",
    "Stop breaking the 4th wall",
    "You should have chosen a different Sponsor",
    "Why bother Terraforming? I like dirt",
    "Growing older is getting murdered",
}

Tremualin.Configuration.RenegadesPerSabotage = 8
Tremualin.Configuration.CrimeTriggersAtHowManyRenegades = 4
-- RebelYell lowers min by 2
Tremualin.Configuration.RebelYellLowersCrimeMinimumBy = 2

local configuration = Tremualin.Configuration

-- Protests lower the morale of all non-renegades in the Dome for 3 sols
function Dome:Tremualin_CrimeEvents_Protest()
    for _, colonist in pairs(self.labels.Colonist or empty_table) do
        if not colonist.traits.Renegade then
            TemporarilyModifyMorale(colonist, -self:GetAdjustedRenegades(), 0, 3, "Tremualin_CrimeEvents_Protest", "Annoying protesters ")
        end
    end

    AddOnScreenNotification("Tremualin_CrimeEvents_Protest", false, {
        dome_name = self:GetDisplayName(),
        protest_text = table.rand(protests_text)}, {
    self:GetPos()}, self:GetMapID())
end

-- Vandalism fills the maintenance bar of a random building
function Dome:Tremualin_CrimeEvents_Vandalism()
    local buildings = (table.ifilter(self.labels.Building or empty_table, function(i, b)
        return IsValid(b) and b:CanDemolish() and b:UseDemolishedState()
    end))
    if #buildings == 0 then
        return
    end
    local vandalized_buildings = {}
    for i = 1, self:GetAdjustedRenegades() do
        local building = self.city:TableRand(buildings)
        if building and building:DoesRequireMaintenance() then
            local maintenance = MulDivRound(building.maintenance_threshold_base, 5, 100)
            building:AccumulateMaintenancePoints(maintenance)
            table.insert(vandalized_buildings, building)
        end
    end
    if #buildings > 0 then
        AddOnScreenNotification("Tremualin_CrimeEvents_Vandalism", false, {
            dome_name = self:GetDisplayName(),
        }, vandalized_buildings, self:GetMapID())
    end
end

-- Stolen resources scale with the number of Renegades
function Dome:CrimeEvents_StoleResource()
    local res_filter = function(o, dome)
        if IsKindOfClasses(o, "SharedStorageBaseVisualOnly", "CargoShuttle") then
            return false
        end
        if "BlackCube" == o.resource or "WasteRock" == o.resource then
            return false
        end
        if IsKindOf(o, "ResourcePile") then
            return o:GetTargetAmount() >= const.ResourceScale
        else
            return o:GetStoredAmount() >= const.ResourceScale
        end
    end
    local resources_stockpile = (MapGet(self, self:GetOutsideWorkplacesDist() * const.HexHeight, "ResourceStockpileBase", res_filter, self))
    local count = #resources_stockpile
    if count <= 0 then
        return false
    end
    local rand_stockpile = 1 + self:Random(count)
    local stockpile = resources_stockpile[rand_stockpile]
    if IsKindOf(stockpile, "ResourcePile") then
        local stored_amount = (stockpile:GetTargetAmount())
        -- Modified by my mod (1 replace with self:GetAdjustedRenegades())
        local rand_res_amount = Min(stored_amount / const.ResourceScale, self:GetAdjustedRenegades()) * const.ResourceScale
        stockpile:AddResource(-rand_res_amount, stockpile.resource)
        AddOnScreenNotification("RenegadesStoleResources", false, {
            dome_name = self:GetDisplayName(),
            resource = FormatResource(self, rand_res_amount, stockpile.resource)}, {
            IsValid(stockpile) and stockpile
        }, self:GetMapID())
        return true
    elseif IsKindOf(stockpile, "ResourceStockpile") then
        local storable_resource = stockpile.resource
        local stored_amount = (stockpile:GetStoredAmount())
        -- Modified by my mod (1 replace with self:GetAdjustedRenegades())
        local rand_res_amount = Min(stored_amount / const.ResourceScale, self:GetAdjustedRenegades()) * const.ResourceScale
        stockpile:AddResource(-rand_res_amount, storable_resource)
        AddOnScreenNotification("RenegadesStoleResources", false, {
            dome_name = self:GetDisplayName(),
            resource = FormatResource(self, rand_res_amount, storable_resource)}, {
            IsValid(stockpile) and stockpile
        }, self:GetMapID())
        return true
    else
        local storable_resources = stockpile.storable_resources
        local resource_count = #storable_resources
        local stored_amount = {}
        local is_mech_depot = (IsKindOf(stockpile, "MechanizedDepot"))
        for i = 1, resource_count do
            local resource = storable_resources[i]
            local amount = is_mech_depot and stockpile:GetIOStockpileStoredAmount() or stockpile:GetStoredAmount(resource)
            if amount >= const.ResourceScale then
                stored_amount[#stored_amount + 1] = {resource, amount}
            end
        end
        local rand_type = 1 + self:Random(#stored_amount)
        local resorce_type = stored_amount[rand_type]
        -- Modified by my mod; resorce_type can sometimes be NIL
        if resorce_type then
            -- Modified by my mod (1 replace with self:GetAdjustedRenegades())
            local rand_res_amount = Min(resorce_type[2] / const.ResourceScale, self:GetAdjustedRenegades()) * const.ResourceScale
            stockpile:AddResource(-rand_res_amount, resorce_type[1])
            AddOnScreenNotification("RenegadesStoleResources", false, {
                dome_name = self:GetDisplayName(),
                resource = FormatResource(self, rand_res_amount, resorce_type[1])}, {
                IsValid(stockpile) and stockpile
            }, self:GetMapID())
        else
            return false
        end
        return true
    end
end

-- Buildings sabotaged now scales with the number of Renegades
function Dome:CrimeEvents_SabotageBuilding()
    local buildings = (table.ifilter(self.labels.Building or empty_table, function(i, b)
        return IsValid(b) and b:CanDemolish() and b:UseDemolishedState()
    end))
    if #buildings == 0 then
        return
    end
    local sabotaged_buildings = {}
    for i = 1, Max(1, self:GetAdjustedRenegades() / configuration.RenegadesPerSabotage) do
        local building, idx = self.city:TableRand(buildings)
        if not building then
            return
        end
        table.remove(buildings, idx)
        if DestroyBuildingImmediate(building, false) then
            table.insert(sabotaged_buildings, building)
        end
    end
    if 0 < #sabotaged_buildings then
        AddOnScreenNotification("Tremualin_Renegades_Sabotage_Buildings", false, {
            dome_name = self:GetDisplayName(),
        }, sabotaged_buildings, self:GetMapID())
    end
    return 0 < #sabotaged_buildings
end

-- Colonists steal some money; no one knows how
function Dome:Tremualin_CrimeEvents_Embezzlement()
    local stolen_amount = MulDivRound(UIColony.funds.funding, self:GetAdjustedRenegades(), 100)
    UIColony.funds.funding = UIColony.funds.funding - stolen_amount

    AddOnScreenNotification("Tremualin_CrimeEvents_Embezzlement", false, {
        dome_name = self:GetDisplayName(),
        stolen_amount = stolen_amount
    }, {self:GetPos()}, self:GetMapID())
end

Tremualin.Configuration.CrimeTable = {
    Protest = {min = 4, weight = 24, event_function = Dome.Tremualin_CrimeEvents_Protest},
    Vandalism = {min = 4, weight = 24, event_function = Dome.Tremualin_CrimeEvents_Vandalism},
    Steal = {min = 8, weight = 18, event_function = Dome.CrimeEvents_StoleResource},
    Embezzlement = {min = 8, weight = 18, event_function = Dome.Tremualin_CrimeEvents_Embezzlement},
    Sabotage = {min = 12, weight = 12, event_function = Dome.CrimeEvents_SabotageBuilding};
}

-- Adding new types of crime
function Dome:CheckCrimeEvents()
    local is_rebel_rule = (IsGameRuleActive("RebelYell"))
    local count = (self:GetAdjustedRenegades())
    local crime_trigger = configuration.CrimeTriggersAtHowManyRenegades
    local rebel_yell_minus = configuration.RebelYellLowersCrimeMinimumBy
    -- No crime if nothing can be triggered
    if (is_rebel_rule and count <= crime_trigger - rebel_yell_minus) or count <= crime_trigger then
        return
    end

    if self:CanPreventCrimeEvents() then
        AddOnScreenNotification("PreventCrime", false, {
            dome_name = self:GetDisplayName()}, {
        self:GetPos()}, self:GetMapID())
        return
    end
    local total_weight = 0
    local weighted_crimes = {}
    for crime_id, crime in pairs(configuration.CrimeTable) do
        local min = crime.min
        if is_rebel_rule then
            min = crime.min - rebel_yell_minus
        end

        if min <= count then
            total_weight = total_weight + crime.weight
            local weighted_crime = {weight = total_weight, event_function = crime.event_function}
            weighted_crimes[#weighted_crimes + 1] = weighted_crime
        end
    end

    if total_weight > 0 then
        local random_number = self:Random(total_weight)
        for i = 1, #weighted_crimes do
            local crime = weighted_crimes[i]
            if random_number <= crime.weight then
                crime.event_function(self)
                break
            end
        end
    end
end
