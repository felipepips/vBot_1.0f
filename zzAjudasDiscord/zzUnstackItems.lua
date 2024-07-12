setDefaultTab("tools")
local itemsIds = {3031} -- items ids to sort (always inside {} example {1234} or {1234,1235,1236})
local bpsIds = {} -- set here bps ids to check (always inside {} example {1234} or {1234,1235,1236} or {} to check all bps)
macro(300, "UnStack Items", function()
  local dest
  local toMove
  for c, cont in pairs(g_game.getContainers()) do
    if table.find(bpsIds,cont:getContainerItem():getId()) or not bpsIds[1] then
      if #cont:getItems() < cont:getCapacity() then
        for i, item in ipairs(cont:getItems()) do
          if table.find(itemsIds,item:getId()) and item:getCount() > 1 then
            toMove = item
            dest = cont
            break
          end
        end
      end
    end
  end
  if not dest or not toMove then return end
  g_game.move(toMove,dest:getSlotPosition(dest:getCapacity()),1)
end)