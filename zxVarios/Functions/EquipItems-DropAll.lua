-- function para cavebot.. tem 2 funções.. 1 pra dropar todos os itens do corpo+bp no chao e outro pra buscar pelo set no chao e equipar

local moveDelay = 350
local errorLabel = "Stop"

--[[
  para usar, inserir function no cavebot:
    return equipItems()
    OU
    return dropAll()
]]

-- EQUIP ITEMS
local equips = {
  [1] = 37164, -- Head = 1
  [2] = 35523, -- Neck = 2
  [3] = 24395, -- Back = 3
  [4] = 25779, -- Body = 4
  [5] = 26948, -- Right = 5
  [6] = 36669, -- Left = 6
  [7] = 34093, -- Leg = 7
  [8] = 35520, -- Feet = 8
  [9] = 39186, -- Finger = 9
  [10] = 25975, -- Ammo = 10
}
-- END CONFIG
equipItems = function()
  local bpId = equips[3]
  local back = getBack()
  local openBp = getContainerByItem(bpId)
  if not back then
    local find = findItemOnGroundInRange(bpId,4)
    if find then
      moveToSlot(find,3)
      CaveBot.delay(moveDelay)
      return "retry"
    else
      -- bp não encontrada no chao.. 
      warn("BP nao encontrada")
      CaveBot.gotoLabel(errorLabel)
      return true
    end
  elseif not openBp then
    g_game.open(back,nil)
    CaveBot.delay(moveDelay)
    return "retry"
  end
  -- equipar items
  for slot, id in pairs(equips) do
    -- verificar se ja esta equipado
    local equipped = getSlot(slot)
    if not equipped or equipped:getId() ~= id then
      local find = findItem(id)
      if find then
        moveToSlot(find,slot)
        CaveBot.delay(moveDelay)
        return "retry"
      else
        -- item nao encontrado para equipar
        CaveBot.gotoLabel(errorLabel)
        warn(id.." equip nao encontrado")
        return true
      end
    end
  end
  -- all done
  CaveBot.delay(moveDelay)
  return true
end

-- DROP ITEMS
local safe_pos = {
  from = {x = 1175, y = 495, z = 7},
  to = {x = 1179, y = 499, z = 7}
}
dropAll = function()
  -- check pos
  local pos = pos()
  if (pos.x < safe_pos.from.x or pos.x > safe_pos.to.x)
    or (pos.y < safe_pos.from.y or pos.y > safe_pos.to.y)
    or (pos.z < safe_pos.from.z or pos.z > safe_pos.to.z) then
    warn("Out of safe position")
    return true
  end
  local slots = {getHead(), getBody(), getLeg(), getFeet(), getNeck(), getLeft(), getRight(), getFinger(), getAmmo()}
  for e, entry in pairs(slots) do
    if entry then
      g_game.move(entry, getBack():getPosition(), entry:getCount())
      CaveBot.delay(moveDelay)
      return "retry"
    end
  end
  if getBack() then
    g_game.move(getBack(),player:getPosition(),1)
    CaveBot.delay(moveDelay)
    return "retry"
  end
  CaveBot.delay(moveDelay)
  return true
end

function getTilesInRange(distance,position,ignoreBelow)
  local t = {}
  local d = distance or 2
  local pos = position or pos()
  for x = -d,d do
    for y = -d,d do
      if not ignoreBelow or x ~= 0 or y ~= 0 then
        local tile = g_map.getTile({pos.x+x,pos.y+y,pos.y})
        if tile then
          table.insert(t,tile)
        end
      end
    end
  end
  return t
end

function findItemOnGroundInRange(id,range,ignoreBelow)
  for i, tile in ipairs(getTilesInRange(range,pos(),ignoreBelow)) do
    for j, item in ipairs(tile:getItems()) do
      if item:getId() == id then return item end
    end
  end
end
