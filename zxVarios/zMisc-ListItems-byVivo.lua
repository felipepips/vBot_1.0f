setDefaultTab("main")
local panelName = "ItemViewer"
local config = storage[panelName]

g_ui.loadUIFromString([[
ItemViewerWindow < MainWindow
  !text: tr('Items Viewer, Made by: VivoDibra#1182')
  size: 1024 750
  @onEscape: self:hide()

  BotContainer
    id: itemList
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    anchors.bottom: separator.bottom
    anchors.top: parent.top
    size: 50 50

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8    

  Button
    id: backButton
    !text: tr('Back')
    font: cipsoftFont
    anchors.left: parent.left
    anchors.bottom: parent.bottom

  Button
    id: nextButton
    !text: tr('Next')
    font: cipsoftFont
    anchors.left: backButton.right
    anchors.bottom: parent.bottom

  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
  
  Label
    id: page
    text: 500/30000
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    width:100
]])

local rootWidget = g_ui.getRootWidget()

local filter = {
  stack = false,
  moveable = false,
}
function listFilter(id)
  local item = Item.create(id)
  if item then
    if filter.stack ~= nil and ((filter.stack and not item:isStackable()) or (not filter.stack and item:isStackable())) then
      return false
    end
    if filter.moveable ~= nil and ((filter.moveable and item:isNotMoveable()) or (not filter.moveable and not item:isNotMoveable()))then
      return false
    end
    return true
  end
  return false
end

if rootWidget then
    ItemViewerWindow = UI.createWindow('ItemViewerWindow', rootWidget)

    ItemViewerWindow:hide()

    ItemViewerWindow.onGeometryChange = function(widget, old, new)
        if old.height == 0 then return end
        config.height = new.height
    end

    -- addButton("","Item Viewer", function()
    --   ItemViewerWindow:show()
    --   ItemViewerWindow:raise()
    --   ItemViewerWindow:focus()
    -- end):setColor("#03fcf4")
    
    local firstPage = 0
    local lastPage = 50000
    local pageSize = 500
    local currentPage = firstPage

    UI.Container(function() end, false, nil, ItemViewerWindow.itemList) 

    local function setItems()     
      local itemsId = { }
        for i=currentPage, (currentPage + pageSize) do
          if listFilter(i) then
            table.insert(itemsId, i)
          end
        end
        ItemViewerWindow.itemList:setItems(itemsId)
        ItemViewerWindow.page:setText(currentPage.."/"..lastPage)
    end

    ItemViewerWindow.closeButton.onClick = function(widget)
        ItemViewerWindow:hide()
    end

    ItemViewerWindow.backButton.onClick = function(widget)
      if currentPage > firstPage then
        currentPage = currentPage - pageSize
        setItems()
      end      
    end

    ItemViewerWindow.nextButton.onClick = function(widget)
      if currentPage < lastPage then
        currentPage = currentPage + pageSize
        setItems()
      end
    end
    setItems()
end

--Join Discord server for free scripts
--https://discord.gg/RkQ9nyPMBH
--Made By VivoDibra#1182
--Tested on vBot 4.8 / OTCV8 3.1 rev 232