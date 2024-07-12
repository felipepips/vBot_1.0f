local m = macro(10000,"Ban Cast",function() end)

local p = 'Spectator (%d+) joined the channel.'
onTextMessage(function(mode, text)
  if m:isOff() then return end
  if not text:find('joined the channel.') then return end
  local spec = text:match(p)
  if spec then
    say("!cast ban, "..spec)
  end
end)