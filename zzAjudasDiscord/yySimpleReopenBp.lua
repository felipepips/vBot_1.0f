-- CaveBot Function, Close Container and Reopen
-- START CONFIG
local containersIds = {2869}
local onlyOpenOne = true
-- END CONFIG

for c, cont in pairs(g_game.getContainers()) do
  local cId = cont:getContainerItem():getId()
  if table.find(containersIds,cId) then
    g_game.close(cont)
    delay(350)
  end
end
schedule(2000,function()
  for c, cont in pairs(g_game.getContainers()) do
    for i, item in pairs(cont:getItems()) do
      if table.find(containersIds,item:getId()) then
        g_game.open(item)
        if onlyOpenOne then break end
      end
    end
  end
end)
delay(3000)
warn("Reopened Container")
return true