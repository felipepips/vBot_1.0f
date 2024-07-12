local leaderName = "Nome pra quem vai enviar msg"

local toSend = {}
local spyMacro = macro(3000,"espiao",function()
  if not toSend[1] then return end
  local text = table.concat(toSend," + ")
  talkPrivate(leaderName,text)
  toSend = {}
end)

onCreatureAppear(function(creature)
  if not spyMacro:isOn() then return end
  if creature:isPlayer() and creature ~= player then
    local cName = creature:getName()
    if not table.find(toSend,cName) then
      table.insert(toSend,cName)
    end
  end
  return true
end)