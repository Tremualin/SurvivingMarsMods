function OnMsg.ClassesPostprocess()
    PlaceObj('AmbientLife', {
        group = "Work",
        id = "WorkOpenAirGym",
        param1 = "unit",
        param2 = "bld",
        PlaceObj('XPrgDefineSlot', {
            'groups', "A",
            'spot_type', "Visitgympullup,Visitwarmup,Visitbasketball",
            'goto_spot', "Pathfind",
            'flags_missing', 1,
            'usable_by_child', false,
        }),
        PlaceObj('XPrgHasVisitTime', {
            'form', "while-do",
            }, {
            PlaceObj('XPrgVisitSlot', {
                'unit', "unit",
                'bld', "bld",
                'group', "A",
                'group_fallback', "Holder",
            }),
        }),
    })

    local _slots = {
        {
            flags_missing = 1,
            goto_spot = "Pathfind",
            groups = {
                ["A"] = true,
            },
            spots = {
                "Visitgympullup",
                "Visitwarmup",
                "Visitbasketball",
            },
            usable_by_child = false,
        },
    }
    PrgAmbientLife["WorkOpenAirGym"] = function(unit, bld)
        local _spot, _obj, _slot_desc, _slot, _slotname
        while unit:VisitTimeLeft() > 0 do
            _spot, _obj, _slot_desc, _slot, _slotname = PrgGetObjRandomSpotFromGroup(bld, nil, "A", _slots, unit)
            if _spot then
                PrgVisitSlot(unit, bld, _obj, _spot, _slot_desc, _slot, _slotname)
                if unit.visit_restart then return end
            else
                PrgVisitHolder(unit, bld)
                if unit.visit_restart then return end
            end
            if unit.visit_restart then return end
        end
    end
end
