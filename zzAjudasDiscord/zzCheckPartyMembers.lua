-- check party members
local partyMembers = {}
local leader = ""

local function clearList()
  partyMembers = {}
  leader = ""
end

local checkParty = macro(1000,"Cade o chinelo",function() 
  local msgEnviada = false
  -- se não estiver em pt, limpa a lista 
  if player:getShield() < 3 then
    return clearList()
  end

  -- faz a lista de membros
  for s, spec in pairs(getSpectators(false)) do
    if spec:getShield() > 2 then
      -- grava o nome do lider
      if spec:getShield() == 4 or spec:getShield() == 6 then 
        if spec:getName() ~= leader then
          clearList() -- novo lider, limpa a lista
          leader = spec:getName() 
        end
      -- insere os membros na table
      elseif not table.find(partyMembers,spec:getName()) then 
        table.insert(partyMembers,spec:getName())
      end 
    end
  end

  -- ver se o lider está perto
  if player:getName() ~= leader and not getCreatureByName(leader) then
    talkPrivate(leader,"Mano me espera pf")
    delay(3000)
    return
  end

  -- ver se alguem sumiu
  for m, member in pairs(partyMembers) do
    if not getCreatureByName(member) then
      if player:getName() ~= leader then talkPrivate(leader,"Mano cade o "..member.."?") end
      talkPrivate(member,"Mano cade voce?")
      msgEnviada = true
    end
  end

  -- ver se tem alguem na vida baixa
  for m, member in pairs(partyMembers) do
    local c = getCreatureByName(member)
    if c and c:getHealthPercent() < 30 then -- percentual de vida para avisar o maluco
      talkPrivate(member,"Vai morrer, fdp?")
      msgEnviada = true
    end
  end
  local c = getCreatureByName(leader)
  if c and c:getHealthPercent() < 30 then -- percentual de vida para avisar o lider
    talkPrivate(member,"Vai morrer, fdp?")
    msgEnviada = true
  end

  if msgEnviada then
    delay(3000)
  end
end)

--bonus, se alguem da pt mandar limpar a lista, vc limpa
-- se alguem falar "hicks" voce pode um gole
onTalk(function(name, level, mode, text, channelId, pos)
  if not checkParty:isOn() then return true end
  if table.find(partyMembers,name) or leader == name then
    if string.find(text:lower(),"limpa a lista") then
      clearList()
    elseif string.find(text:lower(),"hicks!") then
      talkPrivate(name,"Nem pra oferecer...")
      delay(3000)
    end
  end
  return true
end)