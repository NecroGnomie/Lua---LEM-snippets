local mq = require('mq')

-- Do not edit this if condition
if not package.loaded['events'] then
    print('This script is intended to be imported to Lua Event Manager (LEM). Try "\a-t/lua run lem\a-x"')
end

-- Define the logic within the action function LEM expects
local function action()
    -- Check if we have the item, it's out of charges, and we aren't busy
    if mq.TLO.FindItemCount('Bulwark of Many Portals')() > 0 and 
       mq.TLO.FindItem('Bulwark of Many Portals').Charges() < 1 and 
       not mq.TLO.Me.Hovering() and 
       not mq.TLO.Me.Invis() and 
       not mq.TLO.Me.Casting() then

        -- Clear cursor if something is on it
        if mq.TLO.Cursor.ID() then
            print('\agClearing Cursor: \ap' .. mq.TLO.Cursor.Name())
            mq.cmd('/autoinventory')
            mq.delay(200)
        end

        -- Pick up the item
        mq.cmd('/ctrl /itemnotify "Bulwark of Many Portals" leftmouseup')
        mq.delay('1s', function() return mq.TLO.Cursor.ID() == 85491 end)

        -- Double check ID and destroy
        if mq.TLO.Cursor.ID() == 85491 then
            mq.cmd('/destroy')
            print('\arDestroyed: \ay(Empty) \apBulwark of Many Portals.')
        end
    end
end

-- Condition function determines IF the action should run
local function condition()
    return mq.TLO.FindItemCount('Bulwark of Many Portals')() > 0 and 
           mq.TLO.FindItem('Bulwark of Many Portals').Charges() == 0
end

return {
    onload = function() print("\agBulwark Snippet Loaded\ax") end, 
    condfunc = condition, 
    actionfunc = action
}