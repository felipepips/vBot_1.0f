-- AUTO REVIDE / FIGHT BACK / ATTACK PLAYER PK

-- START CONFIG
local macroName = "Fight Back" -- macro name
local pauseTarget = true -- pause targetbot
local pauseCave = true -- pause cavebot
local followTarget = true -- set chase mode to follow
-- END CONFIG

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.

local st = "AutoRevide"
storage[st] = storage[st] or {
  pausedTarget = false,
  pausedCave = false
}
local c = storage[st]
local target = nil
local m = macro(250,macroName, function()
  if not target then
    if c.pausedTarget then
      c.pausedTarget = false
      TargetBot.setOn()
    end
    if c.pausedCave then
      c.pausedCave = false
      CaveBot.setOn()
    end
    return
  end

  local creature = getPlayerByName(target)
  if not creature then target = nil return end
  if pauseTargetBot then
    c.pausedTarget = true
    TargetBot.setOff()
  end
  if pauseTarget then
    c.pausedTarget = true
    TargetBot.setOff()
  end
  if pauseCave then
    c.pausedCave = true
    CaveBot.setOff()
  end

  if followTarget then
    g_game.setChaseMode(2)
  end

  if g_game.isAttacking() then
    if g_game.getAttackingCreature():getName() == target then
      return
    end
  end
  g_game.attack(creature)
end)

onTextMessage(function(mode, text)
  if m:isOff() then return end
  if not text:find('hitpoints due to an attack by') then return end
  local p = 'You lose (%d+) hitpoints due to an attack by (.+)%.'
  local hp, attacker = text:match(p)
  local c = getPlayerByName(attacker)
  if not c then return end
  target = c:getName()
end)