-- small / simple sort items on containers

-- START CONFIG
local itemsToSort = {3191,3155,3160} -- only ids, always inside {}
local containersToFill = {2869,2870} -- only ids, always inside {}
-- END CONFIG

macro(200,"Sort Items",function() 
  local containers = g_game.getContainers()
  local dest = nil
  for c, cont in pairs(containers) do
    local cId = cont:getContainerItem():getId()
    if table.find(containersToFill,cId) then
      if cont:getCapacity() > #cont:getItems() then
        dest = cont
        break
      end
    end
  end

  if not dest then delay(1000) return end

  for c, cont in pairs(containers) do
    local cId = cont:getContainerItem():getId()
    if not table.find(containersToFill,cId) then
      for i, item in pairs(cont:getItems()) do
        if table.find(itemsToSort,item:getId()) then
          g_game.move(item,dest:getSlotPosition(dest:getCapacity()),item:getCount())
          delay(300)
          return
        end
      end
    end
  end
end)