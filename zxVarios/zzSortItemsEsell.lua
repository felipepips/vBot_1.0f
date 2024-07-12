-- START CONFIG
local talkDelay = 2600

local itemsNames = {
  [3358] = 'chain armor',
  [3354] = 'brass helmet',
  [3286] = 'mace',
  [3264] = 'sword',
  [3410] = 'plate shield',
}

setDefaultTab("Main")
-- END CONFIG

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.

local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 140
    !text: tr('Sort Items')

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
      sortItems = { 3358, 3354, 3286, 3264, 3410 },
      sortContainers = { 2854 }
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
      local next = nil
      for i, item in pairs(cont:getItems()) do
        if table.find(itemsToSort,item:getId()) then
          g_game.move(item,dest:getSlotPosition(dest:getCapacity()),item:getCount())
          delay(300)
          return
        end
        if item:isContainer() then
          next = item
        end
      end
      if next ~= nil then
        g_game.open(next,cont)
        delay(300)
        return
      end
    end
  end
end)


macro(100,"Sell Loot",function()
  local itemsToSell = properTable(config.sortItems)
  local lootContainer = properTable(config.sortContainers)
  local containers = g_game.getContainers()

  local sell = {} 
  local toSell = false
  for c, cont in pairs(containers) do
    local cId = cont:getContainerItem():getId()
    if table.find(lootContainer,cId) then
      for i, item in pairs(cont:getItems()) do
        if table.find(itemsToSell,item:getId()) then
          if not sell[item:getId()] then sell[item:getId()] = 0 end
          sell[item:getId()] = sell[item:getId()] + item:getCount()
          toSell = true
        end
      end
    end
  end

  if toSell then
    say('hi')
    local timeTalk = 0
    for e, entry in pairs(sell) do
      local name = itemsNames[e]
      if name then
        schedule(timeTalk,function()
          say('sell '..entry..' '..name)
          say('yes')
        end)
        timeTalk = timeTalk + (talkDelay * 2)
      end
    end
    delay(timeTalk)
  end
end)