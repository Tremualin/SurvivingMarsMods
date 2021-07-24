return {
PlaceObj('ModItemCode', {
	'FileName', "Code/Script.lua",
}),
PlaceObj('ModItemTraitPreset', {
	_incompatible = "Composed",
	category = "Negative",
	description = T(145718526879, --[[ModItemTraitPreset Anxious description]] "-2 sanity when unable to immediately satisfy an interest. Can happen multiple times per day. Just breathe."),
	display_name = T(568836510722, --[[ModItemTraitPreset Anxious display_name]] "Anxious"),
	group = "Negative",
	id = "Anxious",
	incompatible = {
		Composed = true,
	},
	name = "Anxious",
}),
PlaceObj('ModItemTraitPreset', {
	_incompatible = "Listener",
	category = "Negative",
	daily_update_func = 
function (colonist, trait)
local victims = {}
local residence = colonist.residence
if residence and residence.colonists then 
	for i = #residence.colonists, 1, -1 do
    	local victim = residence.colonists[i]
		if IsValid(victim) and victim ~= colonist and victim.traits.Argumentative then
			table.insert(victim, victims)
		end
	end
end

if #victims > 0 then
	local random_number = math.random(0, #victims)
	victims[random_number]:ChangeSanity(-5 * const.Scale.Stat, "Argued with another colonist")
	colonist:ChangeSanity(-5 * const.Scale.Stat, "Started an argument with another colonist")
end
end,
	description = T(480159664894, --[[ModItemTraitPreset Argumentative description]] "Both this and another argumentative colonist in the same residence will lose 5 sanity each day. Because I'm right and he's wrong."),
	display_name = T(473503548526, --[[ModItemTraitPreset Argumentative display_name]] "Argumentative"),
	group = "Negative",
	id = "Argumentative",
	incompatible = {
		Listener = true,
	},
	initial_filter = true,
	name = "Argumentative",
	sanatorium_trait = true,
}),
PlaceObj('ModItemTraitPreset', {
	_incompatible = "Renegade",
	apply_func = 
function (colonist, trait, init)
colonist:SetModifier("base_morale","Depression", -9999 * const.Scale.Stat, 0, "<red>When you have depression, existing is a full-time job</red>")
end,
	category = "Negative",
	daily_update_func = 
function (colonist, trait)
if not isKindOf(colonist.workplace, "Sanatorium") then
	-- Chances of committing suicide
	if colonist:Random(100) < g_Consts.LowSanitySuicideChance then
    	colonist:SetCommand("Suicide")
	end
	-- Chances of developing flaws
	if colonist:Random(100) < g_Consts.LowSanityNegativeTraitChance then
		local compatible = (FilterCompatibleTraitsWith(const.SanityBreakdownTraits, colonist.traits))
		if 0 < #compatible then
			colonist:AddTrait(table.rand(compatible))
		end
	end
	-- High chances of losing interest in daily activities
	if colonist.Random(80) < 100 then 
		colonist.daily_interest = ""
	end
end
if colonist.GetSanity() >= 70 * const.Scale.Stat then
	colonist.ChangeSanity(colonist.GetSanity() - 69 * const.Scale.Stat, "<red>When you have depression, existing is a full-time job</red>")
end
if colonist.GetComfort() >= 70 * const.Scale.Stat then
	colonist.ChangeComfort(colonist.GetComfort() - 69 * const.Scale.Stat, "<red>When you have depression, existing is a full-time job</red>")
end
end,
	description = T(654217586731, --[[ModItemTraitPreset Depressed description]] "Morale is set to 0. Sleeping removes sanity instead of restoring it. Sanity and Comfort are lowered (to 69) at the end of the day. Cannot become a Renegade. Can be obtained as a result of a sanity breakdown. Has an 80% high chance of dropping his daily interest unless assigned to a Sanatorium. Has a small chance of suicide each day unless assigned to a Sanatorium. Has a small chance of developing other negative flaws each day unless assigned to a Sanatorium. Must be removed in the Sanatorium. Smiles a lot at work. -Social"),
	display_icon = "",
	display_name = T(744529179578, --[[ModItemTraitPreset Depressed display_name]] "Depressed"),
	group = "Negative",
	id = "Depressed",
	incompatible = {
		Renegade = true,
	},
	initial_filter = true,
	modify_amount = -5,
	modify_property = "DailySanityRecover",
	modify_target = "self",
	name = "Depressed",
	rare = true,
	remove_interest = "interestSocial",
	sanatorium_trait = true,
	unapply_func = 
function (colonist, trait)
colonist:SetModifier("base_morale", "Depression", 0, 0)
end,
}),
PlaceObj('ModItemTraitPreset', {
	category = "Positive",
	description = T(161721546389, --[[ModItemTraitPreset Crafty description]] "Finds creative ways to produce more resources. +5% bonus resources produced using the same amount of materials (factories and fungal farms love them!). Stacks with other colonists. Available in School."),
	display_name = T(876770941567, --[[ModItemTraitPreset Crafty display_name]] "Crafty"),
	group = "Positive",
	id = "Crafty",
	incompatible = {},
	name = "Crafty",
	rare = true,
}),
PlaceObj('ModItemTraitPreset', {
	_incompatible = "Composed",
	category = "Negative",
	daily_update_func = 
function (colonist, trait)
local victims = {}
local residence = colonist.residence
if residence and residence.colonists then 
	for i = #residence.colonists, 1, -1 do
    	local victim = residence.colonists[i]
		if IsValid(victim) and victim ~= colonist and not victim.traits.Child then
			table.insert(victim, victims)
		end
	end
end

if #victims > 0 then
	local random_number = math.random(0, #victims)
	victims[random_number]:ChangeHealth(-5 * const.Scale.Stat, "Got into a fight with another colonists")
	colonist:ChangeSanity(10 * const.Scale.Stat, "Provoked a fight with another colonist")
end
end,
	description = T(751189543735, --[[ModItemTraitPreset HotHeaded description]] "-5 health to a random non-child on the same workplace or residence and himself when at low sanity. Recovers +10 sanity when this happens. Can die from this."),
	display_name = T(787206239319, --[[ModItemTraitPreset HotHeaded display_name]] "HotHeaded"),
	group = "Negative",
	id = "HotHeaded",
	incompatible = {},
	name = "HotHeaded",
}),
PlaceObj('ModItemTraitPreset', {
	_incompatible = "Mean",
	category = "Positive",
	daily_update_func = 
function (colonist, trait)
local victims = {}
local residence = colonist.residence
if residence and residence.colonists then 
	for i = #residence.colonists, 1, -1 do
    	local victim = residence.colonists[i]
		if IsValid(victim) and victim ~= colonist then
			table.insert(victim, victims)
		end
	end
end

if #victims > 0 then
	local random_number = math.random(0, #victims)
	victims[random_number]:ChangeSanity(5 * const.Scale.Stat, "Another colonist was kind to me")
	colonist:ChangeSanity(5 * const.Scale.Stat, "Feels good to be kind")
end
end,
	description = T(435767739758, --[[ModItemTraitPreset Kind description]] "+5 Sanity to a random colonist in the same residence. Recovers +5 sanity when this happens. "),
	display_name = T(540302319362, --[[ModItemTraitPreset Kind display_name]] "Kind"),
	group = "Positive",
	id = "Kind",
	incompatible = {
		Mean = true,
		Morbid = true,
	},
	name = "Kind",
}),
PlaceObj('ModItemTraitPreset', {
	_incompatible = "Argumentative",
	category = "Default",
	daily_update_func = 
function (colonist, trait)
local colonist_with_lowest_sanity = nil
local residence = colonist.residence
if residence and residence.colonists then 
	for i = #residence.colonists, 1, -1 do
    	local victim = residence.colonists[i]
		if IsValid(victim) and victim ~= colonist then
				if colonist_with_lowest_sanity and colonist_with_lowest_sanity.stat_sanity > victim.stat_sanity then
					colonist_with_lowest_sanity = victim
				else
					colonist_with_lowest_sanity = victim
				end
		end
	end
end
if colonist_with_lowest_sanity then 
	victim:ChangeSanity(10 * const.Scale.Stat, "Someone listened to my woes")
	colonist:ChangeSanity(-5 * const.Scale.Stat, "It ain't easy being a good listener")		
end
end,
	description = T(810886541611, --[[ModItemTraitPreset Listener description]] "The colonist with the lowest sanity in the residence gets +10 sanity. But this colonist will lose 5 sanity."),
	display_name = T(936788763981, --[[ModItemTraitPreset Listener display_name]] "Listener"),
	group = "other",
	id = "Listener",
	incompatible = {
		Argumentative = true,
	},
	name = "Listener",
}),
PlaceObj('ModItemTraitPreset', {
	category = "Positive",
	description = T(461747561353, --[[ModItemTraitPreset Masochist description]] "Gains (+5) sanity when health is below 70. Gains (+15) sanity when health is below 30."),
	display_name = T(584366254858, --[[ModItemTraitPreset Masochist display_name]] "Masochist"),
	group = "Positive",
	id = "Masochist",
	incompatible = {},
	name = "Masochist",
}),
PlaceObj('ModItemTraitPreset', {
	_incompatible = "Kind",
	category = "Negative",
	daily_update_func = 
function (colonist, trait)
local victims = {}
local residence = colonist.residence
if residence and residence.colonists then 
	for i = #residence.colonists, 1, -1 do
    	local victim = residence.colonists[i]
		if IsValid(victim) and victim ~= colonist then
			table.insert(victim, victims)
		end
	end
end

if #victims > 0 then
	local random_number = math.random(0, #victims)
	victims[random_number]:ChangeSanity(-5 * const.Scale.Stat, "Another colonist was mean to me")
	colonist:ChangeSanity(5 * const.Scale.Stat, "Feels good to be mean")
end
end,
	description = T(692728959809, --[[ModItemTraitPreset Mean description]] "-5 sanity to a random person on the same residence. Recovers +5 sanity when this happens."),
	display_name = T(306220161089, --[[ModItemTraitPreset Mean display_name]] "Kind"),
	group = "Negative",
	id = "Mean",
	incompatible = {
		Kind = true,
		Virtuous = true,
	},
	initial_filter = true,
	name = "Mean",
	sanatorium_trait = true,
}),
PlaceObj('ModItemTraitPreset', {
	category = "Default",
	description = T(851641314421, --[[ModItemTraitPreset Philistine description]] "Won't use any building that satisfies luxury or work on workshops. -Luxury"),
	display_name = T(812766066980, --[[ModItemTraitPreset Philistine display_name]] "Philistine"),
	group = "other",
	id = "Philistine",
	incompatible = {},
	name = "Philistine",
}),
PlaceObj('ModItemTraitPreset', {
	_incompatible = "Morbid,Mean",
	category = "Positive",
	daily_update_func = 
function (colonist, trait)
-- do something
end,
	description = T(100540164638, --[[ModItemTraitPreset Nurturer description]] "Recovers (+10) sanity and gains (+10)(3 day) morale when a new colonist is born in the dome. Has (+20) higher performance as long as everyone is happy in the dome."),
	display_name = T(582247024691, --[[ModItemTraitPreset Nurturer display_name]] "Nurturer"),
	group = "Positive",
	id = "Nurturer",
	incompatible = {
		Mean = true,
		Morbid = true,
	},
	name = "Virtuous",
	rare = true,
}),
PlaceObj('ModItemTraitPreset', {
	_incompatible = "Nurturer",
	category = "Negative",
	daily_update_func = 
function (colonist, trait)
local dome = colonist.dome
if dome and dome.labels.Senior then  
    colonist:SetModifier("performance", "Tremualin_Mordid", 20 * const.Scale.Stat, 0, "<green>Morbidly excited about Seniors in dome</green>")
end
end,
	description = T(661796369926, --[[ModItemTraitPreset Morbid description]] "Recovers (+10) sanity and gains (+10) (3 day) morale when another colonist dies in the dome. Has (+20) higher performance if there are Seniors in the dome."),
	display_name = T(386687096075, --[[ModItemTraitPreset Morbid display_name]] "Morbid"),
	group = "Positive",
	id = "Morbid",
	incompatible = {
		Kind = true,
		Virtuous = true,
	},
	initial_filter = true,
	name = "Morbid",
}),
}
