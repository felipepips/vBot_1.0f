-- REFILL // ADVANCED
-- BY F.ALMEIDA

-- START CONFIG
local BP_CHAR = 2854
local BP_SUPPLY = 2871
local items = {
  --[ID] = {min = QUANTIDADE},
  [3160] = {min = 500},
  [19470] = {min = 700},
}
local maxDist = 5 -- max range to look around
local moveDelay = 500 -- in milliseconds
-- END CONFIG

local tag = "[House Refill]\n"
if retries > 200 then 
  warn(tag.."Error!")
  return true
end

-- ver se a bp de loot está aberta
local lootBp = getContainerByItem(BP_SUPPLY)
if lootBp then
  -- ver quanto de supply ja tem
  for c, cont in pairs(getContainers()) do
    local cId = cont:getContainerItem():getId()
    if cId ~= BP_SUPPLY then
      for i, item in ipairs(cont:getItems()) do
        local id = item:getId()
        if items[id] then
          items[id].atual = items[id].atual or 0
          items[id].atual = items[id].atual + item:getCount()
        end
      end
    end
  end
  -- ver o q precisa refilar
  local toRefill = {}
  local refilar = false
  for id, info in pairs(items) do
    if not info.atual or info.atual < info.min then
      toRefill[id] = info.min - (info.atual or 0)
      refilar = true
    end
  end
  -- refilar
  if not refilar then
    warn(tag.."Refilado!")
    return true
  else
    local next = nil
    for i, item in ipairs(lootBp:getItems()) do
      local falta = toRefill[item:getId()]
      if falta then
        local toMove = item:getCount() < falta and item:getCount() or falta
        local dest = getContainerByItem(BP_CHAR,true)
        if not dest then
          warn(tag.."Char sem BP??")
          return true
        else
          g_game.move(item,dest:getSlotPosition(dest:getCapacity()),toMove)
          delay(moveDelay)
          return 'retry'
        end
      elseif item:getId() == BP_SUPPLY then
        next = item
      end
    end
    if next then
      g_game.open(next,lootBp)
      delay(moveDelay)
      return 'retry'
    else
      warn(tag.."Acabou Supply")
      return true
    end
  end
else
  -- achar a bp no chao
  local pos = player:getPosition()
  for xp = -maxDist,maxDist do
    for yp = -maxDist,maxDist do
      local rTile = g_map.getTile({x = pos.x + xp, y = pos.y + yp, z = pos.z})
      if rTile then
        local topItem = rTile:getTopUseThing()
        if topItem and topItem:getId() == BP_SUPPLY then
          g_game.use(topItem)
          delay(moveDelay)
          return 'retry'
        end
      end
    end
  end
end

warn(tag.."Bp de Supply nao encontrada.")
return true