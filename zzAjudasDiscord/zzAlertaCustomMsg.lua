-- CUSTOM MESSAGE ALERT (onTalk & onTextMessage)

-- START CONFIG
setDefaultTab("Main")
local macroName = "Custom MSG Alert"
local flashClient = true
local clientWindowText = "Custom Message"
local soundStyle = "/sounds/alarm.ogg"
-- END CONFIG

storage.customMessageAlert = storage.customMessageAlert or "Insert Text Here"

local lastCall = now
local function alarm()
  if lastCall > now then return end
  if modules.game_bot.g_app.getOs() == "windows" and flashClient then g_window.flash() end
  g_window.setTitle(player:getName() .. " - " .. clientWindowText)
  playSound(soundStyle)
  lastCall = now + 6000 -- alarm.ogg length is 6s
end

local customAlert = macro(5*60*1000,macroName,function() end)

UI.TextEdit(storage.customMessageAlert, function(widget, newText)
  storage.customMessageAlert = newText
end)

onTextMessage(function(mode, text)
  if not customAlert:isOn() then return true end
  text = text:lower()
  if not text:find(storage.customMessageAlert:lower()) then return true end
  print("Global onTextMessage Mode: "..mode.." Text: "..text)
  alarm()
end)

onTalk(function(name, level, mode, text, channelId, pos)
  if not customAlert:isOn() then return true end
  text = text:lower()
  if not text:find(storage.customMessageAlert:lower()) then return true end
  local posText = pos and " Pos: "..pos.x.." "..pos.y.." "..pos.x or ""
  print("Global onTalk - Name: "..name.." Level: "..level.." Mode: "..mode.." Text: "..text.." ChannelId: "..channelId..posText)
  alarm()
end)