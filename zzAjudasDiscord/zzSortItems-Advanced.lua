setDefaultTab("Tools")

local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 140
    !text: tr('Sort Items / Fast Loot')

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Edit
]])

local edit = setupUI([[
Panel
  height: 135
    
  Label
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Items to Sort:

  BotContainer
    id: sortItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 70

  Label
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Containers to Fill:

  BotContainer
    id: sortContainers
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 35
]])
edit:hide()

if not storage.sortItems then
    storage.sortItems = {
      enabled = false,
      sortItems = { 3031, 3035 },
      sortContainers = {}
    }
end

local config = storage.sortItems

local showEdit = false
ui.edit.onClick = function(widget)
  showEdit = not showEdit
  if showEdit then edit:show()
  else edit:hide()
  end
end

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget) config.enabled = not config.enabled ui.title:setOn(config.enabled) end

UI.Container(function() config.sortItems = edit.sortItems:getItems() end, true, nil, edit.sortItems)
edit.sortItems:setItems(config.sortItems)

UI.Container(function() config.sortContainers = edit.sortContainers:getItems() end, true, nil, edit.sortContainers) 
edit.sortContainers:setItems(config.sortContainers)

local function properTable(t)
  local r = {}
  for _, entry in pairs(t) do
    table.insert(r, entry.id)
  end
  return r
end

macro(100,function() 
  if not config.enabled then return end
  local itemsToSort = properTable(config.sortItems)
  local containersToFill = properTable(config.sortContainers)
  local containers = g_game.getContainers()
  local dest = nil
  for c, cont in pairs(containers) do
    local cId = cont:getContainerItem():getId()
    if table.find(containersToFill,cId) then
      if cont:getCapacity() > #cont:getItems() then
        dest = cont
        break
      end
    end
  end

  if not dest then delay(1000) return end

  for c, cont in pairs(containers) do
    local cId = cont:getContainerItem():getId()
    if not table.find(containersToFill,cId) then
      for i, item in pairs(cont:getItems()) do
        if table.find(itemsToSort,item:getId()) then
          g_game.move(item,dest:getSlotPosition(dest:getCapacity()),item:getCount())
          delay(300)
          return
        end
      end
    end
  end
end)