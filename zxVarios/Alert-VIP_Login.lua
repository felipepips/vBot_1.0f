-- VIP LOGIN ALERT
do
  -- START CONFIG
  local MAIN_CHARACTER_NAME = "Main Character Name Here"
  local MACRO_NAME = "VIP Login Alert"
  local ALERT_INTERVAL = 6000 -- 6 seconds
  -- END CONFIG

  local vipAlarm = macro(500000,MACRO_NAME,function() end)
  local last = 0
  onTextMessage(function(mode, text)
    if not vipAlarm:isOn() then return end
    if last + ALERT_INTERVAL > now then return end
    if mode == 19 and text:find('has logged in') then
      playAlarm()
      talkPrivate(MAIN_CHARACTER_NAME,text)
      last = now
    end
  end)
end