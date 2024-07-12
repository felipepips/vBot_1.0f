-- START CONFIG
setDefaultTab("Tools")
local macroName = "Custom msg alert"
-- Define the array of alert messages
local alertMessages = {
    "warning! the murder of",
    "danger! beware of",
    "attention! deadly attack from",
    "The following items are available in your reward chest:",
    -- Add more alert messages if needed
}
-- END CONFIG

local m = macro(132123131, macroName, function() end)

onTextMessage(function(mode, text)
  if not m.isOn() then return end
  for _, alertMessage in ipairs(alertMessages) do
    if text:lower():find(alertMessage:lower()) then
      playAlarm()
      g_window.flash()
      break
    end
  end
end) 