local chName = "Terminal"
local function log(msgColor,...)
  local mod = modules.game_console
  local ch = mod.getTab(chName)
  if not ch then
    mod.addTab(chName,false)
  end
  local msg = ""
  local args = {...}
  local appendSpace = #args > 1
  for i,v in ipairs(args) do
    msg = msg .. tostring(v)
    if appendSpace and i < #args then
      msg = msg .. ' , '
    end
  end
  mod.addTabText(msg,{speakType = 6, color = msgColor},ch)
end

function print(...)
  return log('#9dd1ce',...)
end

function warn(...)
  return log('#FFFF00',...)
end

function error(...)
  return log('#F55E5E',...)
end

macro(1000,"teste",function()
  print("isso","eh","um","print")
  warn("isso","eh","um","warn")
  error("isso","eh","um","error")
end)