--START CONFIG
local item_do_chao = {1234,1235,1236}
local item_para_usar = 3214
local max_range = 6
local pause_cave = true
local restart_cave = 1 -- segundos de delay para retomar o cavebot
--END CONFIG


local pausedCave
macro(500,"UseWith on Ground",function()
  local pos = player:getPosition()
  for x = -max_range, max_range do
    for y = -max_range, max_range do
      local tile = g_map.getTile({x = pos.x + x, y = pos.y + y, z = pos.z})
      if tile then
        local topItem = tile:getTopUseThing()
        if topItem then
          if table.find(item_do_chao,topItem:getId()) then
            if pause_cave and CaveBot.isOn() and not pausedCave then CaveBot.setOff() pausedCave = true end
            useWith(item_para_usar,topItem)
            schedule(restart_cave*1000,function() 
              if pausedCave then CaveBot.setOn() pausedCave = false end
            end)
            delay(restart_cave)
            return
          end
        end
      end
    end
  end
end)