local t = {}
local tempo = 10000 -- miliseg, vai contar só quem atacou nesse intervalo

local icone = addIcon("qqNome", {text="", item = 3280, switchable=false, phantom=true}, function() end)
icone.text:setColor("yellow")
icone.text:setFont("verdana-11px-rounded")

macro(100,function()
  local count = 0
  for e, entry in pairs(t) do
    if entry > (now - tempo) then 
      count = count + 1
    end
  end
  icone.text:setText(count)
end)

onTextMessage(function(mode, text)
  if text:find('hitpoints due to an attack by') then
    local p = 'You lose (%d+) hitpoints due to an attack by (.+)%.'
    local hp, attacker = text:match(p)
    local c = getCreatureByName(attacker)
    if c and c:isPlayer() then
      t[attacker] = now
    end
  elseif text:find("You are dead") then
    local msg = "Atacantes:"
    for e, entry in pairs(t) do
      msg = msg .. "\n" ..e
    end
    print(msg)
  end
end)