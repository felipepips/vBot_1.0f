-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

setDefaultTab("Cave")

local stName = "SendParcel"
storage[stName] = storage[stName] or {sendItems = {3043}}
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
    !text: tr('Send Parcel Config')
    font: verdana-11px-rounded
    color: yellow
]])

local edit = setupUI([[
Panel
  height: 80
    
  Label
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    text-align: center
    text: Items to Send:
    font: verdana-11px-rounded

  BotContainer
    id: sendItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 70
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
  config.sendItems = properTable(edit.sendItems:getItems())
  end, true, nil, edit.sendItems) 
edit.sendItems:setItems(config.sendItems)
config.sendItems = properTable(edit.sendItems:getItems())

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL