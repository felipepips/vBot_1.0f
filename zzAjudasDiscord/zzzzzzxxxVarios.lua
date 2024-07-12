local ui = setupUI([[
Panel
  height: 150
  width: 130
  anchors.left: parent.left
  anchors.top: parent.top
  margin-left: 3

  Label
    id: label1
    margin-top: 50
    font: verdana-11px-rounded
    anchors.top: parent.top
    anchors.left: parent.left
    width: 120       
]], modules.game_interface.getMapPanel())    

-- set colored text
local cores = {"white","blue","yellow","green","black","orange","gray"}
macro(150,function()
  local cor1, cor2, cor3, cor4 = cores[math.random(#cores)],cores[math.random(#cores)],cores[math.random(#cores)],cores[math.random(#cores)]
  ui.label1:setColoredText({"Trocando ", cor1, "de", cor2," cor",cor3," :)",cor4})
end)

-- broadcast msg
macro(500,"teste",function()
  modules.game_textmessage.displayBroadcastMessage("melhor ainda")
end)

-- add tab text
local text = "blabla"
local speakType = {color = '#9F9DFD'}
local tab = modules.game_console.getTab("Server Log")
local creatureName = player:getName()
modules.game_console.addTabText(text, speakType, tab, creatureName)

-- pegar nome de unjust
onTextMessage(function(mode, text)
  if string.find(text, "Warning!") then
    local textMurder = [[Warning! The murder of ([a-z A-Z]*) was not justified.]]
    local re = regexMatch(text, textMurder)
    if not re[1] then return end
    say(re[1][2])
  end
end)

-- Criar Efeito
macro(750,"Send Effect",function()
  local tile = g_map.getTile(player:getPosition())
  if tile then
    local fx = Effect.create()
    fx:setId(56)
    tile:addThing(fx)
  end
end)

-- janela multi-line
UI.Button("Block Players", function(newText) 
  UI.MultilineEditorWindow("", {title="Blocked Players List", description="Add the name of the players to be blocked from the party.\nExample:\nPlayer 1\nPlayer 2\nPlayer 3", width=250, height=200}, function(text)
  end)
end)