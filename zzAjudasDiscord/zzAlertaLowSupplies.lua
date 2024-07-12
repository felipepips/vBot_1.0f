-- START CONFIG
local flashClient = true
local windowText = "Low Supplies"
local soundStyle = "/sounds/alarm.ogg"
-- END CONFIG


local lastCall = now
local function alarm()
    if now - lastCall < 2000 then return end -- 2s delay
    lastCall = now
  
    if modules.game_bot.g_app.getOs() == "windows" and flashClient then
      g_window.flash()
    end

    g_window.setTitle(player:getName() .. " - "..windowText)
    playSound(soundStyle)
  end

local alertMsg = macro(5000,"Low Supplies Alert", function() 
  if hasSupplies() ~= true then
    return alarm()
  end
end)
