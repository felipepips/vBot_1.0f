-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

-- SCRIPT MADE BY F.Almeida#8019 - if you are reading this, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD
  
setDefaultTab("Tools")

UI.Separator()
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
    color: green
]])

local edit = setupUI([[
Panel
  height: 137
    
  Label
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    text-align: center
    text: Items To Deposit:

  BotContainer
    id: depositItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 64

  Label
    anchors.top: prev.bottom
    margin-top: 3
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Containers To Deposit:

  BotContainer
    id: depositContainers
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32
]])
edit:hide()

if not storage.oldDepositConfig then
    storage.oldDepositConfig = {
      depositItems = { 3079 },
      depositContainers = {2869}
    }
end

local config = storage.oldDepositConfig

local showEdit = false
ui.edit.onClick = function(widget)
  showEdit = not showEdit
  if showEdit then
    edit:show()
  else
    edit:hide()
  end
end

UI.Container(function()
    config.depositItems = edit.depositItems:getItems()
    end, true, nil, edit.depositItems) 
edit.depositItems:setItems(config.depositItems)

UI.Container(function()
    config.depositContainers = edit.depositContainers:getItems()
    end, true, nil, edit.depositContainers) 
edit.depositContainers:setItems(config.depositContainers)

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL