
local minHp = 50 -- se estiver abaixo de x% hp, fica dentro de casa
local ignoreParty = true -- ignorar party members
local ignoreMonsters = false -- ignorar monstros
local positions = {
  sair = {32345,32217,7},
  entrar = {32345,32219,7},
}

local function go(t)
  autoWalk({x=t[1],y=t[2],z=t[3]}, 10, {precision = 0})
end

macro(500,"House RuneMaker",function()
  if hppercent() <= minHp then
    return go(positions.entrar)
  end
  for s, spec in pairs(getSpectators(false)) do
    if spec ~= player then
      if (not ignoreMonsters and spec:isMonster()) or (spec:isPlayer() and (not ignoreParty or spec:getShield() < 3)) then
        return go(positions.entrar)
      end
    end
  end
  return go(positions.sair)
end)