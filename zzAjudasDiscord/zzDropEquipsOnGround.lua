iDrop = function()
  local time = 0
  local slots = {getHead(), getBody(), getLeg(), getFeet(), getNeck(), getLeft(), getRight(), getFinger(), getAmmo()}
  for e, entry in pairs(slots) do
    if entry then
      schedule(time,function() 
        g_game.move(entry, getBack():getPosition(), entry:getCount())
      end)
      time = time + 150
    end
  end
  schedule(time,function() 
    if getBack() then g_game.move(getBack(),player:getPosition(),1) end
  end)
  return true
end

onTalk(function(name, level, mode, text, channelId, pos)
  if string.find(text,"blablabla") then
    iDrop()
  end
end)