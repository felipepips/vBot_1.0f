-- CONFIGURAR AQUI:
local idPouch = 2869
local lootIds = {1111,2222,3333,4444}


-- NÃO MEXER EM NADA ABAIXO
local getPouch = function()
  local pouch = nil
  local containers = g_game.getContainers()
  for c, container in pairs(containers) do
    local cId = container:getContainerItem():getId()
    if cId == idPouch then 
      pouch = container 
      break
    end
  end
  return pouch
end

macro(250,"Move To Pouch",function()
  local containers = g_game:getContainers()
  local pouch = pouch or getPouch()
  if not pouch then return end
  for c, container in pairs(containers) do
    if container:getContainerItem():getId() ~= idPouch then
      for i, item in ipairs(container:getItems()) do
        if table.find(lootIds,item:getId()) then
          return g_game.move(item,pouch:getSlotPosition(1),item:getCount())
        end
      end
    elseif nextPage:isOn() and container:hasPages() then 
      local nextPageButton = container.window:recursiveGetChildById('nextPageButton')
      if nextPageButton then nextPageButton.onClick() end
    end
  end
end)

nextPage = macro(1*60*1000, "Pouch Next Page", function()
end)
  