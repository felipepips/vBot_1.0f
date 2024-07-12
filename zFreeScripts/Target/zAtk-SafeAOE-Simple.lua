-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

-- TARGETED RUNE (PRIORIDADE ALTA)
local qntd_mob_usar_sd = 3 -- ou mais
local sd_id = 3155

-- TARGETED SPELL (PRIORIDADE MEDIA)
local hp_targeted = 70 -- percentual
local targeted_spell = "exori mort"

-- AOE SPELL (PRIORIDADE BAIXA)
local aoe_mana_percent = 50
local qntd_mob_usar_aoe = 2 -- ou mais
local aoe_spell = "exevo gran mas pox"

-- DISTANCIAS
local distancia_para_contar_monstros = 2
local distancia_para_contar_players = 7

-- MISC
local exhausted = 1000 -- ms
local macroName = "SD/Ue/Frigo"
local iconName = "Safe\nAOE"

---------- END CONFIG

local function getDist(creature)
  return getDistanceBetween(creature:getPosition(),pos())
end

local function getTarget()
  local tgt = nil
  if g_game.isAttacking() then
    tgt = g_game.getAttackingCreature()
  end
  return tgt
end

macro(250,macroName,function()
  if isInPz() then return end

  -- get distribution
  local mobs = 0
  local players = 0
  for s, spec in ipairs(getSpectators()) do
    if spec ~= player then
      if spec:isPlayer() and getDist(spec) <= distancia_para_contar_players then
        players = players + 1
      elseif spec:isMonster() and getDist(spec) <= distancia_para_contar_monstros then
        mobs = mobs + 1
      end
    end
  end

  -- get Attacking creature
  local focus = getTarget()

  -- high priority // targeted rune
  if focus and mobs >= qntd_mob_usar_sd and findItem(sd_id) then
    useWith(sd_id,focus)
    return delay(exhausted)
  end
  
  -- medium priority // targeted spell
  local mp = manapercent()
  if focus and (players > 0 or focus:getHealthPercent() <= hp_targeted or mobs < qntd_mob_usar_aoe or mp < aoe_mana_percent) then
    say(targeted_spell)
    return delay(exhausted)
  end

  -- low priority // aoe spell
  if focus and mp >= aoe_mana_percent and mobs >= qntd_mob_usar_aoe and players == 0 then
    say(aoe_spell)
    return delay(exhausted)
  end
end)

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL