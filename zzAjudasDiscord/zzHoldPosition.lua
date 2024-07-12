-- Hold Position

local t = nil
local lurar = macro(100,"Hold Position",function(m)
  local p = player:getPosition()
  schedule(50,function() 
    if m:isOff() then t = nil end
  end)
  
  if t == nil then t = p end
  if table.equals(p, t) then return end
  if findPath(p,t) then return autoWalk(t) end

  for _, tile in pairs(getNearTiles(t)) do
    local pos = tile:getPosition()
    if findPath(p,pos) then return autoWalk(pos) end
  end

end)
