-- Jogar este arquivo na pasta raiz do bot ou colar o código abaixo em 'in-game script editor'
-- Put this file on bot root folder or paste this code inside the 'in-game script editor'

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL


setDefaultTab("Cave")

local stName = "DepositerV2"
local config = storage[stName]

local ui = setupUI([[
Panel
  height: 19

  Button
    id: edit
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    margin-top: 1
    width: 176
    height: 17
    !text: tr('Depositer Config')
    font: verdana-11px-rounded
]])

local edit = setupUI([[
DepositerBox < CheckBox
  font: verdana-11px-rounded
  margin-top: 5
  margin-left: 5
  anchors.top: prev.bottom
  anchors.left: parent.left
  anchors.right: parent.right
  color: lightGray

Panel
  height: 210
    
  Label
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    text-align: center
    text: Items To Deposit:
    font: verdana-11px-rounded

  BotContainer
    id: depositItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 70

  Label
    anchors.top: prev.bottom
    margin-top: 3
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Containers To Deposit:
    font: verdana-11px-rounded

  BotContainer
    id: depositContainers
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 35

  DepositerBox
    id: sOld
    text: Old Versions
    !tooltip: tr('Check it if you only have 1 depot chest in your locker')

  DepositerBox
    id: sDepositAll
    text: Deposit All
    !tooltip: tr('Deposit All items from loot list in TargetBot')

  BotTextEdit
    id: sDelay
    width: 83
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    font: verdana-11px-rounded

  Label
    text: Default Delay:
    font: verdana-11px-rounded
    anchors.left: parent.left
    margin-left: 5
    anchors.verticalCenter: sDelay.verticalCenter    

  BotTextEdit
    id: sDepotName
    width: 83
    anchors.bottom: sDelay.top
    anchors.right: parent.right
    font: verdana-11px-rounded

  Label
    text: Depot Name:
    font: verdana-11px-rounded
    anchors.left: parent.left
    margin-left: 5
    anchors.verticalCenter: sDepotName.verticalCenter    
]])
edit:hide()

local showEdit = false
ui.edit.onClick = function(widget)
  showEdit = not showEdit
  if showEdit then
    edit:show()
  else
    edit:hide()
  end
end

local function properTable(t)
  local r = {}
  if #t == 0 then return r end
  for _, entry in pairs(t) do
    if type(entry) == 'number' then
      table.insert(r, entry)
    else
      table.insert(r, entry.id)
    end
  end
  return r
end

-- Bot Containers
UI.Container(function()
  config.depositItems = properTable(edit.depositItems:getItems())
  end, true, nil, edit.depositItems) 
edit.depositItems:setItems(config.depositItems)
config.depositItems = properTable(edit.depositItems:getItems())

UI.Container(function()
  config.depositContainers = properTable(edit.depositContainers:getItems())
  end, true, nil, edit.depositContainers) 
edit.depositContainers:setItems(config.depositContainers)
config.depositContainers = properTable(edit.depositContainers:getItems())

-- Check Boxes
edit.sOld:setChecked(config.sOld)
edit.sOld.onClick = function(widget)
  config.sOld = not config.sOld
  widget:setChecked(config.sOld)
  widget:setImageColor(config.sOld and "green" or "red")
end
edit.sOld:setImageColor(config.sOld and "green" or "red")

edit.sDepositAll:setChecked(config.sDepositAll)
edit.sDepositAll.onClick = function(widget)
  config.sDepositAll = not config.sDepositAll
  widget:setChecked(config.sDepositAll)
  widget:setImageColor(config.sDepositAll and "green" or "red")
end
edit.sDepositAll:setImageColor(config.sDepositAll and "green" or "red")

-- Text Edit
edit.sDelay:setText(config.sDelay)
edit.sDelay.onTextChange = function(widget, text)
  config.sDelay = tonumber(text)
end

edit.sDepotName:setText(config.sDepotName)
edit.sDepotName.onTextChange = function(widget, text)
  config.sDepotName = text
end

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL