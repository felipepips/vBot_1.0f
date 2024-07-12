-- TITULO
UI.Label(">> Custom Outfit <<"):setColor("yellow")

-- NÃO MEXER
storage.outfitChanger = storage.outfitChanger or {player:getOutfit()}
storage.outfitChanger2 = storage.outfitChanger2 or {player:getOutfit()}

-- UI TEXT EDIT
UI.TextEdit(storage.outfitChanger.type, function(widget, newText)
  storage.outfitChanger.type = newText
end)

-- UI BUTTON, TROCAR OUTFIT
UI.Button("Trocar Outfit",function()
  storage.outfitChanger2 = player:getOutfit()
  setOutfit(storage.outfitChanger)
end)

-- UI BUTTON, VOLTAR OUTFIT
UI.Button("Voltar Outfit",function()
  setOutfit(storage.outfitChanger2)
end)

-- UI BUTTON, COPY OUTFIT
UI.Button("Salvar Cores Atuais",function()
  local oldType = storage.outfitChanger.type
  storage.outfitChanger = player:getOutfit()
  storage.outfitChanger.type = oldType
end)

-- DESCOBRIR OUTFITS DA TELA
UI.Button("Pegar Types da Tela",function()
  local msg = ''
  for s, spec in pairs(getSpectators()) do
    if not spec:isMonster() then
      msg = msg .. spec:getName() .. " " .. spec:getOutfit().type .. ", "
    end
  end
  talkPrivate(player:getName(),msg)
end)

-- PARTY OUTFIT
UI.Label(">> Party Outfit <<"):setColor("yellow")
local pto = macro(12312313,"Auto Change Outfit",function()end)
onTalk(function(name, level, mode, text, channelId, pos)
  if not pto:isOn() then return end
  if channelId ~= getChannelId('Party') then return end
  print("Global onTalk - Name: "..name.." Level: "..level.." Mode: "..mode.." Text: "..text.." ChannelId: "..channelId..posText)
end)
