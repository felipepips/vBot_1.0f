-- Player Attack Alarm
-- tags: alert alerts alarms pk sound

-- START CONFIG
local macroName = "Alarm PK"
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
    if spec ~= player and spec:isPlayer() and spec:isTimedSquareVisible() and spec:getShield() < 3 then
      if modules.game_bot.g_app.getOs() == "windows" and flashClient then g_window.flash() end
      g_window.setTitle(player:getName() .. " - "..windowText)
      playSound(soundStyle)
      delay(3000)
    end
  end
end)