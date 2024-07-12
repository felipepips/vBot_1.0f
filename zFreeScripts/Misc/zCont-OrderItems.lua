-- macro para organizar itens por ID, de uma bp para outra

local id_bp_fonte = 2869
local id_bp_destino = 2871
macro(500,"Organizar Items BP",function(m)
  local moveDelay = 350
  local time = 0
  local dest = getContainerByItem(id_bp_destino,true)
  local containers = getContainers()
  for c, cont in pairs(containers) do
    if cont:getContainerItem():getId() == id_bp_fonte then
      local order = {}
      for i, item in ipairs(cont:getItems()) do
        table.insert(order,item)
      end
      table.sort(order, function(a,b) return a:getId() > b:getId() end)
      for e, entry in pairs(order) do
        schedule(time,function()
          if dest then
            g_game.move(entry,dest:getSlotPosition(dest:getCapacity()),1)
          else
            g_game.move(entry,cont:getSlotPosition(cont:getCapacity()),entry:getCount())
          end
        end)
        time = time + moveDelay
      end
    end
  end
  delay(time + moveDelay)
  m:setOff()
end)