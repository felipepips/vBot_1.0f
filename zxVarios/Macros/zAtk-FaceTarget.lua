macro(200,"Face Target",function()
  if not g_game.isAttacking() then return end
  local cpos = g_game.getAttackingCreature():getPosition()
  local pos = player:getPosition()
  local diffx = cpos.x - pos.x
  local diffy = cpos.y - pos.y
  local candidates = {}
  if diffx == 1 and diffy == 1 then
    candidates = {{x=pos.x+1, y=pos.y, z=pos.z}, {x=pos.x, y=pos.y-1, z=pos.z}}
  elseif diffx == -1 and diffy == 1 then
    candidates = {{x=pos.x-1, y=pos.y, z=pos.z}, {x=pos.x, y=pos.y-1, z=pos.z}}
  elseif diffx == -1 and diffy == -1 then
    candidates = {{x=pos.x, y=pos.y-1, z=pos.z}, {x=pos.x-1, y=pos.y, z=pos.z}} 
  elseif diffx == 1 and diffy == -1 then
    candidates = {{x=pos.x, y=pos.y-1, z=pos.z}, {x=pos.x+1, y=pos.y, z=pos.z}}       
  else
    local dir = player:getDirection()
    if diffx == 1 and dir ~= 1 then turn(1)
    elseif diffx == -1 and dir ~= 3 then turn(3)
    elseif diffy == 1 and dir ~= 2 then turn(2)
    elseif diffy == -1 and dir ~= 0 then turn(0)
    end
  end
  for _, candidate in ipairs(candidates) do
    local tile = g_map.getTile(candidate)
    if tile and tile:isWalkable() then
      autoWalk(candidate, 10, {precision = 0, ignoreNonPathable=true})
      delay(350)
      return
    end
  end
end)