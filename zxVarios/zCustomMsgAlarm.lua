
local cmMacro = macro(500000,"Quepedeando Alarm",function() end)
local last = 0

function play()
  if last + 6000 < now then
    last = now
    playAlarm()
  end
end

onTalk(function(name, level, mode, text, channelId, pos)
  if not cmMacro:isOn() then return end
  if text:find("Te estan quepedeando") then
    talkPrivate(player:getName(),"onTalk "..mode)
  end
end)

onTextMessage(function(mode, text)
  if not cmMacro:isOn() then return end
  if text:find("Te estan quepedeando") then
    talkPrivate(player:getName(),"onTextMessage "..mode)
  end
end)

onStaticText(function(thing, text)
  if not cmMacro:isOn() then return end
  if text:find("Te estan quepedeando") then
    talkPrivate(player:getName(),"onStaticText")
  end
end)

onAnimatedText(function(thing,text)
  if not cmMacro:isOn() then return end
  if text:find("Te estan quepedeando") then
    talkPrivate(player:getName(),"onAnimatedText")
  end
end)