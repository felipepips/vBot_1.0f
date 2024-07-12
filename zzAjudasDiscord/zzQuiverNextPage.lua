local ammo = {762}

macro(100,"Move To Quiver",function()
  local containers = g_game.getContainers()
  local dest = nil
  for c, cont in pairs(containers) do
    if string.find(cont:getName():lower(),"quiver") then
      if cont:hasPages() then 
        local nextPageButton = cont.window:recursiveGetChildById('nextPageButton')
        if nextPageButton then
          g_game.seekInContainer(cont:getId(), cont:getFirstIndex() + cont:getCapacity())
        end
      end
      dest = cont
      break
    end
  end

  if not dest then delay(1000) return end

  for c, cont in pairs(containers) do
    if not string.find(cont:getName():lower(),"quiver") then
      for i, item in pairs(cont:getItems()) do
        if table.find(ammo,item:getId()) then
          g_game.move(item,dest:getSlotPosition(1),item:getCount())
          delay(300)
          return
        end
      end
    end
  end
end)