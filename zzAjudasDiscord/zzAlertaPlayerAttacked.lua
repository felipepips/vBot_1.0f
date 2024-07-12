-- Player on Screen Alarm
-- tags: alert alerts alarms sound attack pk appear

-- START CONFIG
local macroName = "Alarm PK"
local ignoreParty = true -- true = ignore party members
local onlySkulled = false -- true = alert only if player have skull
local onlyIfAttacked = false -- true = alert only if someone attacks you
-- end of basic config
local flashClient = true
local windowText = "Player Attack"
local soundStyle = "/sounds/alarm.ogg"
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

macro(100,macroName,function() 
  for s, spec in pairs(getSpectators(false)) do
    if spec ~= player and spec:isPlayer() then
      if not ignoreParty or spec:getShield() < 3 then
        if not onlySkulled or spec:getSkull() > 2 then
          if not onlyIfAttacked or spec:isTimedSquareVisible() then
            if modules.game_bot.g_app.getOs() == "windows" and flashClient then g_window.flash() end
            g_window.setTitle(player:getName() .. " - "..windowText)
            playSound(soundStyle)
            delay(6000)
            break
          end
        end
      end
    end
  end
end)