local fxMacro = macro(213131311,"esconder effects",function()end)

onAddThing(function(tile,thing)
  if fxMacro:isOff() then return end
  thing:setHidden(true)
end)

onStaticText(function(thing, text)
  if fxMacro:isOff() then return end
  g_map.cleanTexts()
end)

onAnimatedText(function(thing,text)
  if fxMacro:isOff() then return end
  g_map.cleanTexts()
end)