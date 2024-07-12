-- -- GET NEXT POSITION
-- local offset = {
--   [0] = {0,-1},
--   [1] = {1,0},
--   [2] = {0,1},
--   [3] = {-1,0},
-- }
-- function spec:getNextPosition()
--   local off = offset[spec:getDirection()]
--   local pos = spec:getPosition()
--   pos.x, pos.y = pos.x + off[1], pos.y + off[2]
--   local tile = g_map.getTile(pos)
--   if tile then
--     return tile:getPosition()
--   end
-- end

-- pegar id dos containers abertos
macro(100,"pegar id container",function(m)
  for c, cont in pairs(getContainers()) do
    print(cont:getName(),cont:getContainerItem():getId())
  end
  m:setOff()
end)

-- previous container / up button
macro(1000,"Prev Cont",function()
  for c, cont in pairs(g_game.getContainers()) do
    local cWindow = cont.window
    if cWindow then
      local upButton = cWindow:recursiveGetChildById('upButton')
      if upButton then
        upButton.onClick()
      end
    end
  end
end)

-- Container Next Page
macro(1000,"Container Next Page",function()
  for c, cont in pairs(g_game.getContainers()) do
    local cWindow = cont.window
    if cWindow then
      local nextPageButton = cWindow:recursiveGetChildById('nextPageButton')
      if nextPageButton and nextPageButton:isEnabled() then
        return nextPageButton.onClick()
      end
    end
  end
end)

-- fast atk
macro(50, "Fast Attack", function()
  for i, spec in ipairs(getSpectators(false)) do
    if spec:isMonster() then
      g_game.attack(spec)
      g_game.cancelAttack() 
      break
    end
  end
end)

-- use item from ground on player
local potion_id = 1234
local player_name = "Frederico"
macro(500,"Pot do Chao kk",function()
  local findPot = findItemOnGround(potion_id)
  if findPot then
    local friend = getCreatureByName(player_name)
    if friend then
      return useWith(findPot,friend)
    end
  end
end)

macro(100,"descobrir right panel",function(m)
  local rPanel = modules.game_interface.getRightPanel()
  local childs = rPanel:getChildren()
  for c, child in ipairs(childs) do
    print(child:getId())
  end
  m:setOff()
end)

macro(100,"descobrir paineis root",function(m)
  local root = g_ui.getRootWidget()
  local childs = root:getChildren()
  for c, child in ipairs(childs) do
    print(child:getId())
  end
  m:setOff()
end)