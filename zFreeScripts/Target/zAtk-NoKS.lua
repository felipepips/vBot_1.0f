-- [[script para não dar KS (ignora monstros que tiver player em volta)]]

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

--[[
  Editar targetbot\creature.lua

  Procurar por:
    TargetBot.Creature.getConfigs = function(creature)
      if not creature then return {} end
    
  Substituir por:
    TargetBot.Creature.getConfigs = function(creature)
      if not creature or creature.noKS then return {} end
]]

local ksMacro = macro(10000000,"NO KS",function() end)

function isPlayerAround(pos)
  local near = getNearTiles(pos)
  for t, tile in pairs(near) do
    for s, spec in pairs(tile:getCreatures()) do
      if spec:isPlayer() and spec ~= player then
        return true
      end
    end
  end
  return false
end

onAttackingCreatureChange(function(new, old)
  if ksMacro:isOff() or not new then return end
  if new:isMonster() and isPlayerAround(new:getPosition()) then
    new.noKS = true
    g_game.cancelAttackAndFollow()
  end
end)

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL