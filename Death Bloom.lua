local mq = require('mq')

-- 1. Configuration & Class Guard
-- Class check must be inside a function or formatted correctly to avoid script termination
if mq.TLO.Me.Class.ShortName() ~= "NEC" then return end

local MANA_THRESHOLD = 70
local ABILITY_NAME = "Death Bloom"

-- 2. Condition Function (condfunc)
-- This determines if the action should even be considered
local function should_use_bloom()
    -- Safety Checks
    if mq.TLO.Me.Invis() or mq.TLO.Me.Casting() or mq.TLO.Me.Moving() then
        return false
    end

    -- Threshold Check
    if mq.TLO.Me.PctMana() >= MANA_THRESHOLD then
        return false
    end

    -- Readiness Check
    if not mq.TLO.Me.AltAbilityReady(ABILITY_NAME)() then
        return false
    end

    return true
end

-- 3. Action Function (actionfunc)
-- This executes only if condfunc returns true
local function do_bloom()
    local currentMana = mq.TLO.Me.PctMana()
    local abilityID = mq.TLO.AltAbility(ABILITY_NAME).ID()
    
    if abilityID > 0 then
        print(string.format("[LEM] Mana low (%d%%). Using %s.", currentMana, ABILITY_NAME))
        -- Using /alt activate is the most reliable way for AAs in MQ
        mq.cmdf("/alt activate %d", abilityID)
    end
end

-- 4. LEM Table Return
return {
    -- Ensure the keys match what your LEM core is looking for
    onload = function() print("LEM Death Bloom module loaded.") end,
    condfunc = should_use_bloom, 
    actionfunc = do_bloom
}