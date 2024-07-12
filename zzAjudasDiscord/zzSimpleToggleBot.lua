-- HOTKEY TO START/STOP (TOGGLE) BOTH CAVEBOT AND TARGETBOT

-- START CONFIG
local hotkey = "Pause"
-- END CONFIG

singlehotkey(hotkey,"Toggle Cave+Target",function() 
  if TargetBot.isOn() and CaveBot.isOn() then
    TargetBot.setOff()
    CaveBot.setOff()
  else
    TargetBot.setOn()
    CaveBot.setOn()
  end
end)