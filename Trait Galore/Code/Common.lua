local print_debug = false

if print_debug then
    -- Helps debug changes in sanity
    local orig_Colonist_ChangeSanity = Colonist.ChangeSanity
    function Colonist:ChangeSanity(amount, reason)
        if amount > 0 then
            if reason and reason ~= "rest" then print (string.format("Changing sanity : %s", reason)) end
        end
        orig_Colonist_ChangeSanity(self, amount, reason)
    end
end
