-- Auto UI panel, switches and icons constructor

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- panel settings
local createBotPanel = true
local defaultTab = "Main"
local mainButtonName = "PVP Hotkeys + Icons"
local mainButtonColor = "yellow"
local switchesAlwaysVisible = false -- if false, click on main button to show the others switches
-- icon settings
local createIcons = true
local iconsStartPos = {x=200,y=250} -- starting position of icons
local iconsDirection = {x=0,y=1} -- south = {x=0,y=1} // north {x=0,y=-1} // west = {x=-1,y=0} // east = {x=1,y=0} // also, if you want double padding, you can set 2 instead of 1
local iconSizeWithItem = {x=50,y=50}
local iconSizeOnlyText = {x=100,y=20}
local iconTextAlign = AlignLeft
local iconTextOn = "green"
local iconTextOff = "red"
local iconBreakAnchors = false -- true = always reset to original position when restart bot // false = save positions // setting break anchors to false will not respect iconStartPos and direction at the first time, but gonna save positions on player storage
-- global settings
local fontStyle = "verdana-11px-rounded"

local offsetDirections = {
  [North] = { 0, -2 },
  [East] = { 2, 0 },
  [South] = { 0, 2 },
  [West] = { -2, 0 },
  [NorthEast] = { 1, -1 },
  [SouthEast] = { 1, 1 },
  [SouthWest] = { -1, 1 },
  [NorthWest] = { -1, -1 }
}

local mwallId = 3180
local paralyzeId = 3165
local potId = 3465

-- main functions -- executed onClick
local function mwTarget()
  local target = g_game.getAttackingCreature()
  if not target then return true end

  local targetPos = target:getPosition()
  local targetDir = target:getDirection()
  
  targetPos.x = targetPos.x + offsetDirections[targetDir][1]
  targetPos.y = targetPos.y + offsetDirections[targetDir][2]
  
  local mwallTile = g_map.getTile(targetPos)
  if not mwallTile then return true end
  local toPos = mwallTile:getTopUseThing()
  if not toPos then return true end
  useWith(mwallId, toPos)
end

local function paralyzeTarget()
  local target = g_game.getAttackingCreature()
  if not target then return true end
  useWith(paralyzeId, target)
end

local function potTarget()
  local target = g_game.getAttackingCreature()
  if not target then return true end

  local targetPos = target:getPosition()
  local targetDir = target:getDirection()
  
  targetPos.x = targetPos.x + offsetDirections[targetDir][1]
  targetPos.y = targetPos.y + offsetDirections[targetDir][2]
  
  local mwallTile = g_map.getTile(targetPos)
  if not mwallTile then return true end
  local toPos = mwallTile:getTopUseThing()
  if not toPos then return true end
  g_game.move(findItem(potId),toPos:getPosition(),1)
end

local function fullPotTarget()
  local target = g_game.getAttackingCreature()
  if not target then return true end

  local targetPos = target:getPosition()
  local near = getNearTiles(targetPos)
  for t, tile in pairs(near) do
    if tile then
      g_game.move(findItem(potId),tile:getPosition(),1)
    end
  end
end

local function takeBack()
  local near = getNearTiles(player:getPosition())
  for t, tile in pairs(near) do
    if tile then
      local item = tile:getTopUseThing()
      if item and item:getId() == potId then
        for c, cont in pairs(g_game.getContainers()) do
          if cont:getCapacity() > #cont:getItems() then
            g_game.move(item,cont:getSlotPosition(cont:getCapacity()),item:getCount())
          end
        end
      end
    end
  end
end

-- check status function -- executed in loop
local function checkMw()
  if itemAmount(mwallId) > 0 then return true else return false end
end

local function checkParalyze()
  if itemAmount(paralyzeId) > 0 then return true else return false end
end

local function checkPot()
  if itemAmount(potId) > 0 then return true else return false end
end

local function checkFullPot()
  if itemAmount(potId) > 7 then return true else return false end
end

local function contarPots() end

-- tips :)
-- don't declare hotkey inside icon settings, do it on main table
-- if you dont want an item in your icon, just set id=0
-- if you receive ERROR: [BOT] /modules/corelib/util.lua:55: bad argument #1 to 'pairs' (table expected, got nil)
-- probably you have set an invalid hotkey :)
local panels = { 
  {name="MW Target",hotkey="",mainFunction=mwTarget,checkFunction=checkMw,createIcon=true,
  iconDetails={text="MW Target", item = {id=mwallId,count=1}, switchable=false, hotkey=nil, movable=true}
  },
  {name="Paralyze Target",hotkey="",mainFunction=paralyzeTarget,checkFunction=checkParalyze,createIcon=true,
  iconDetails={text="Paralyze", item = {id=paralyzeId,count=1}, switchable=false, hotkey=nil, movable=true}
  },
  {name="1 Pot Target",hotkey="",mainFunction=potTarget,checkFunction=checkPot,createIcon=true,
  iconDetails={text="1 Pot", item = {id=potId,count=1}, switchable=false, hotkey=nil, movable=true}
  },
  {name="8 Pot Target",hotkey="",mainFunction=fullPotTarget,checkFunction=checkFullPot,createIcon=true,
  iconDetails={text="8 Pot", item = {id=potId,count=5}, switchable=false, hotkey=nil, movable=true}
  },
  {name="Take Back",hotkey="",mainFunction=takeBack,checkFunction=contarPots,createIcon=true,
  iconDetails={text="Take Back", item = {id=2854,count=1}, switchable=false, hotkey=nil, movable=true}
  },
}
-- END CONFIG

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.

-- start creating bot panel
if createBotPanel then
setDefaultTab(defaultTab)
UI.Separator()
local main = setupUI([[
Panel
  height: 19

  Button
    id: show
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    margin-top: 1
    width: 176
    height: 17
]])
main.show:setFont(fontStyle) 
main.show:setText(mainButtonName)
main.show:setColor(mainButtonColor)

g_ui.loadUIFromString([[
ContentBox < Panel
  margin-top: 0
  layout:
    type: verticalBox
    fit-children: true
    
  Panel
    id: buttons
    margin-top: 1
    layout:
      type: grid
      cell-size: 86 20
      cell-spacing: 1
      flow: true
      fit-children: true
]])

  box = UI.createWidget("ContentBox")
  if not switchesAlwaysVisible then
    box:hide()

    local showEdit = false
    main.show.onClick = function()
      showEdit = not showEdit
      if showEdit then box:show() else box:hide() end
    end
  end
end
-- finish bot panel

-- start creating widgets
local lastPos = iconsStartPos
for i = 1,#panels do
  local data = panels[i]

  -- creating switch
  if createBotPanel then
    local switch = addSwitch(data.name.."Switch",data.name.." ["..data.hotkey.."]",function() data.mainFunction() end,box)
    switch:setWidth(176) -- switch width
    switch:setFont(fontStyle) -- switch font syle
  end

  -- creating icon
  if createIcons and data.createIcon then
    local info = data.iconDetails
    local icon = addIcon(data.name.."Icon", {item={id=info.item.id,count=info.item.count},switchable=info.switchable, hotkey=info.hotkey, movable=info.movable, text=info.text},function() data.mainFunction() end)
    icon:setId(data.name.."Icon")
    icon.text:setFont(fontStyle) -- icon font style
    icon.text:setTextAlign(iconTextAlign) -- text align
    icon:setSize({width=iconSizeWithItem.x,height=iconSizeWithItem.y})
    -- icon resize if there's no item (only text)
    if math.abs(iconsDirection.y) ~= 0 then -- if direction = horizontal, let's keep the same size
      if not info.item or info.item.id < 1 then icon:setSize({width=iconSizeOnlyText.x,height=iconSizeOnlyText.y}) end
    end
     -- icon position
    if iconBreakAnchors then icon:breakAnchors() end
    local a,b = lastPos.x,lastPos.y
    icon:move(a,b)
    local size = icon:getSize()
    lastPos = {x=lastPos.x + (size.width*iconsDirection.x),y=lastPos.y + (size.height*iconsDirection.y)}
  end

  -- binding hotkey
  if data.hotkey and type(data.hotkey) == 'string' and data.hotkey ~= "" then
    singlehotkey(data.hotkey,function() data.mainFunction() end)
  end
end

-- main loop for check status
macro(100,function()
  for i = 1,#panels do
    local data = panels[i]
    local funcReturn = data.checkFunction()
    -- switches
    if createBotPanel then
      local switch = box:getChildById(data.name.."Switch")
      if switch and type(funcReturn) == "boolean" then switch:setOn(funcReturn) end
    end
    -- icons
    if createIcons and data.createIcon then
      local panel = modules.game_interface.getMapPanel()
      local icon = panel:getChildById(data.name.."Icon")
      if icon then 
        if type(funcReturn) == "string" then
          icon.text:setColor("white") 
          icon.text:setText(funcReturn) 
        elseif type(funcReturn) == "table" then
          icon.text:setColoredText(funcReturn) 
        elseif type(funcReturn) == "boolean" then
          icon.text:setColor(funcReturn and iconTextOn or iconTextOff) 
        end
      end
    end
  end
end)

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL