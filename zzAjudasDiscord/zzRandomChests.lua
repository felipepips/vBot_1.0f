-- Use item on ground while hunting -- Cursed / Random Chests
-- Pause cavebot when any of these id's appears on screen and use/open it
-- if it's a random loot chest, set loot_chest = true // it's gonna take all items from inside

-- START CONFIG
local macroName = "Open Cursed Chests" -- Just the name of the macro, set whatever you want
local chest_ids = {2471} -- always inside {} -- e.g. {1234} or {1234,1235,1236}
local max_distance = 6
local delay = 2000 -- delay to re-start cavebot/follow after pausing to use item
local loot_chest = true -- if you want to take items from inside this chest
local follow_macro = followMacro -- put here your follow macro if you want to pause it, or leave it = false
-- END CONFIG

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.

local pausedCave = false
local pausedFollow = false

macro(1000,macroName,function(m)
  for x = -max_distance, max_distance do
    for y = -max_distance, max_distance do
      local pos = player:getPosition()
      local tile = g_map.getTile({x = pos.x + x, y = pos.y + y, z = pos.z})
      if tile and (x ~= 0 or y ~= 0) then
        local topItem = tile:getTopUseThing()
        if topItem then
          if table.find(chest_ids,topItem:getId()) then
            if CaveBot.isOn() and not pausedCave then CaveBot.setOff() pausedCave = true end
            if follow_macro and follow_macro:isOn() and not pausedFollow then follow_macro:setOff() pausedFollow = true end
            g_game.use(topItem)
            if loot_chest then lootChest:setOn() end
            schedule(loot_chest and delay*2 or delay,function() 
              if pausedCave then CaveBot.setOn() pausedCave = false end
              if pausedFollow then follow_macro:setOn() pausedFollow = false end
              m:setOn() 
              lootChest:setOff()
            end)
          return m:setOff()
          end
        end
      end
    end
  end
end)

lootChest = macro(50,function()
  local moveTo = nil
  for c, cont in pairs(g_game.getContainers()) do
    if table.find(chest_ids,cont:getContainerItem():getId()) then
      for d, dest in pairs(g_game.getContainers()) do
        if not table.find(chest_ids,dest:getContainerItem():getId()) then
          if not string.find(dest:getName(),"dead") and not string.find(dest:getName(),"slain")
          and not string.find(dest:getName(),"quiver") and dest:getCapacity() > #dest:getItems() then 
            moveTo = dest
            break
          end
        end
      end
      if moveTo then
        for i, item in ipairs(cont:getItems()) do
          return g_game.move(item,moveTo:getSlotPosition(moveTo:getCapacity()),item:getCount())
        end
      end
    end
  end
end)

lootChest:setOff()