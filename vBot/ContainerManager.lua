setDefaultTab("tools")

-- general settings
local cGreen = '#00FF00' -- green color for UI
local cRed = '#FF0000' -- red color for UI
local tag = "[Container Manager]\n" -- used for console log
local purseId = 23396 -- purse ID
local slotsQuiver = {getAmmo(), getLeft(), getRight()} -- where should we look for a quiver?
local defaultDelay = 300 -- never less than 250

-- End of basic settings.

-- Original made by Lee#7225
-- https://trainorcreations.com/coding/otclient/36
-- Improved by Vithrax
-- Revamped by F.Almeida

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.

-- default storage
local panelName = "cManager"
if type(storage[panelName]) ~= "table" then
  storage[panelName] = {
    openBack = true,
    openPurse = false,
    reopenAtLogin = true,
    openQuiver = false,
    sortItems = true,
    qtdFullAfk = 1,
    onFullAfk = false,
    pausedCave = false,
    list = {
      {
        eId = 2854,
        eName = "Main",
        eEnabled = true,
        eMinimize = false,
        eInfinite = false,
        ePages = false,
        eFull = false,
        eOpenNext = true,
        eRename = true,
        eResize = true,
        eItems = { 3027, 3028, 3029, 3030 },
      }
    }
  }
end
local config = storage[panelName]

-- default switch
local cManager = macro(10000, "Container Manager", function() end)
cManager.switch:setFont("verdana-11px-rounded")

-- UI
local CM = setupUI([[
Panel
  height: 36

  BotSwitch
    id: onFullAfk
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 90
    height: 17
    !text: tr('Full AFK:')
    tooltip: Stop cavebot to reopen BPs and how many BPs should be open to proceed caveboting.
    font: verdana-11px-rounded

  SpinBox
    id: qtdFullAfk
    anchors.top: onFullAfk.top
    anchors.left: onFullAfk.right
    text-align: left
    width: 40
    height: 18
    margin-left: 3
    minimum: 1
    maximum: 15
    step: 1
    editable: true
    tooltip: How many BPs should be open to proceed caveboting
    font: verdana-11px-rounded

  Button
    id: mainSetup
    anchors.top: onFullAfk.top
    anchors.left: prev.right
    margin-top: -1
    anchors.right: parent.right
    margin-left: 3
    height: 18
    text: Setup
    font: verdana-11px-rounded

  Button
    id: mainReopen
    !text: tr('Re-Open All')
    anchors.left: parent.left
    anchors.top: prev.bottom
    anchors.right: parent.horizontalCenter
    margin-right: 2
    height: 17
    margin-top: 3
    font: verdana-11px-rounded

  Button
    id: mainMinimize
    !text: tr('Minimize All')
    anchors.top: prev.top
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-right: 2
    height: 17
    font: verdana-11px-rounded
  ]])
CM:setId(panelName)

g_ui.loadUIFromString([[
BackpackName < Label
  background-color: alpha
  text-offset: 18 2
  focusable: true
  height: 17
  font: verdana-11px-rounded

  CheckBox
    id: eEnabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    width: 15
    height: 15
    margin-top: 1
    margin-left: 3

  $focus:
    background-color: #00000055

  Button
    id: eRemove
    !text: tr('X')
    font: verdana-11px-rounded
    !tooltip: tr('Remove')
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 15
    width: 15
    height: 15

  Button
    id: eMinimize
    !text: tr('M')
    font: verdana-11px-rounded
    anchors.right: eRemove.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 1
    width: 15
    height: 15
    tooltip: Open Container Minimized

  Button
    id: eOpenNext
    !text: tr('O')
    font: verdana-11px-rounded
    anchors.right: eMinimize.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 1
    width: 15
    height: 15
    tooltip: Open Containers inside

  Button
    id: eResize
    !text: tr('S')
    font: verdana-11px-rounded
    anchors.right: eOpenNext.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 1
    width: 15
    height: 15
    tooltip: Resize Container (Open Small)

  Button
    id: eRename
    !text: tr('N')
    font: verdana-11px-rounded
    anchors.right: eResize.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 1
    width: 15
    height: 15
    tooltip: Rename Container

  Button
    id: eInfinite
    !text: tr('I')
    font: verdana-11px-rounded
    anchors.right: eRename.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 1
    width: 15
    height: 15
    tooltip: Inifinite Container: Move items even if it's full

  Button
    id: eFull
    !text: tr('F')
    font: verdana-11px-rounded
    anchors.right: eInfinite.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 1
    width: 15
    height: 15
    tooltip: Open Next Container (same id) only when it's full

  Button
    id: ePages
    !text: tr('P')
    font: verdana-11px-rounded
    anchors.right: eFull.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 1
    width: 15
    height: 15
    tooltip: Auto Next Page Container

CMUI < MainWindow
  !text: tr('Container Manager - Revamped by F.Almeida')
  font: verdana-11px-rounded
  size: 550 250
  @onEscape: self:hide()

  TextList
    id: containerList
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: separator.top
    width: 250
    margin-bottom: 6
    margin-top: 3
    margin-left: 3
    vertical-scrollbar: containerListScrollBar

  VerticalScrollBar
    id: containerListScrollBar
    anchors.top: containerList.top
    anchors.bottom: containerList.bottom
    anchors.right: containerList.right
    step: 14
    pixels-scroll: true

  VerticalSeparator
    id: sep
    anchors.top: parent.top
    anchors.left: containerList.right
    anchors.bottom: separator.top
    margin-top: 3
    margin-bottom: 6
    margin-left: 10

  Label
    id: lblName
    anchors.left: sep.right
    anchors.top: sep.top
    width: 70
    text: Name:
    margin-left: 10
    margin-top: 3
    font: verdana-11px-rounded

  TextEdit
    id: contName
    anchors.left: lblName.right
    anchors.top: sep.top
    anchors.right: parent.right
    font: verdana-11px-rounded

  Label
    id: lblCont
    anchors.left: lblName.left
    anchors.verticalCenter: contId.verticalCenter
    width: 70
    text: Container:
    font: verdana-11px-rounded

  BotItem
    id: contId
    anchors.left: contName.left
    anchors.top: contName.bottom
    margin-top: 3

  BotContainer
    id: sortList
    anchors.left: prev.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    anchors.bottom: separator.top
    margin-bottom: 6
    margin-top: 3

  Label
    anchors.left: lblCont.left
    anchors.verticalCenter: sortList.verticalCenter
    width: 70
    text: Items: 
    font: verdana-11px-rounded

  Button
    id: addContainer
    anchors.right: contName.right
    anchors.top: contName.bottom
    margin-top: 5
    text: Add
    width: 40
    font: verdana-11px-rounded
    color: green

  Button
    id: clear
    anchors.right: addContainer.left
    anchors.top: contName.bottom
    margin-top: 5
    margin-right: 5
    text: Clear
    width: 40
    font: verdana-11px-rounded
    color: red

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8

  CheckBox
    id: sortItems
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    text: Sort Items
    tooltip: Sort items based on items widget
    width: 95
    height: 15
    margin-top: 2
    margin-left: 3
    font: verdana-11px-rounded    

  CheckBox
    id: openBack
    anchors.left: prev.right
    anchors.bottom: parent.bottom
    text: Main BP
    tooltip: Open Main Backpack
    width: 70
    height: 15
    margin-top: 2
    margin-left: 3
    font: verdana-11px-rounded

  CheckBox
    id: openPurse
    anchors.left: prev.right
    anchors.bottom: parent.bottom
    text: Purse
    tooltip: Open Purse (id 23396)
    width: 60
    height: 15
    margin-top: 2
    margin-left: 15
    font: verdana-11px-rounded

  CheckBox
    id: reopenAtLogin
    anchors.left: prev.right
    anchors.bottom: parent.bottom
    text: ReOpen
    tooltip: Close and Reopen all containers at login or bot restart
    width: 70
    height: 15
    margin-top: 2
    margin-left: 15
    font: verdana-11px-rounded

  CheckBox
    id: openQuiver
    anchors.left: prev.right
    anchors.bottom: parent.bottom
    text: Quiver
    !tooltip: tr("Open Quiver (Container on hand or ammo slot)")
    width: 70
    height: 15
    margin-top: 2
    margin-left: 15
    font: verdana-11px-rounded

  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-top: 15
    font: verdana-11px-rounded

  Button
    id: credits
    !text: tr('Credits')
    font: cipsoftFont
    anchors.right: closeButton.left
    anchors.bottom: parent.bottom
    color: yellow
    size: 50 21
    margin-top: 15
    margin-right: 5
    font: verdana-11px-rounded    
    !tooltip: tr('Original made by Lee#7225\nImproved by Vithrax\nRevamped by F.Almeida#8019')
    @onClick: g_platform.openUrl("https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD")

  ResizeBorder
    id: bottomResizeBorder
    anchors.fill: separator
    height: 3
    minimum: 170
    maximum: 245
    margin-left: 3
    margin-right: 3
    background: #ffffff88
]])

-- core functions
-- parse container list in a proper table
local cList = {}
local function parseContainerList()
  cList = {}
  for e, entry in pairs(config.list) do
    if entry.eEnabled then
      table.insert(cList, entry.eId)
    end
  end
  return cList
end
parseContainerList()

-- parse list of sort items in a proper table
local sList = {}
local function parseSortItems()
  for e, entry in pairs(config.list) do
    if entry.eEnabled then
      for i, item in pairs(entry.eItems) do
        local id = type(item) == 'table' and item.id or item
        sList[id] = entry.eId
      end
    end
  end
  return sList
end
parseSortItems()

-- find container config by ID
local function findContainerConfig(id)
  for e, entry in pairs(config.list) do
    if entry.eId == id then
      return e
    end
  end
  return false
end

-- UI FUNCTIONS
rootWidget = g_ui.getRootWidget()
if rootWidget then

  -- create CM Window
  CMUI = UI.createWindow('CMUI', rootWidget)
  CMUI:hide()

  -- panel buttons
  -- main 'settings/setup'
  CM.mainSetup.onClick = function(widget)
    CMUI:show()
    CMUI:raise()
    CMUI:focus()
  end

  -- reopen all
  CM.mainReopen.onClick = function(widget)
    reopenContainers()
  end

  -- minimize all
  CM.mainMinimize.onClick = function(widget)
    for i, container in pairs(g_game.getContainers()) do
      local cWindow = container.window
      cWindow:setContentHeight(34)
      cWindow:minimize()
    end
  end

  -- Full AFK
  CM.onFullAfk:setOn(config.onFullAfk)
  CM.onFullAfk.onClick = function(widget)
    config.onFullAfk = not config.onFullAfk
    widget:setOn(config.onFullAfk)
  end

  -- Qntd Full AFK
  CM.qtdFullAfk:setValue(config.qtdFullAfk)
  CM.qtdFullAfk.onValueChange = function(widget, value)
    config.qtdFullAfk = value
  end

  -- CM Window Buttons
  -- Close Window
  CMUI.closeButton.onClick = function(widget)
    CMUI:hide()
  end

  -- Sort Items
  CMUI.sortItems.onClick = function(widget)
    config.sortItems = not config.sortItems
    CMUI.sortItems:setChecked(config.sortItems)
  end
  CMUI.sortItems:setChecked(config.sortItems)

  -- Open Back
  CMUI.openBack.onClick = function(widget)
    config.openBack = not config.openBack
    CMUI.openBack:setChecked(config.openBack)
  end
  CMUI.openBack:setChecked(config.openBack)

  -- Open Purse
  CMUI.openPurse.onClick = function(widget)
    config.openPurse = not config.openPurse
    CMUI.openPurse:setChecked(config.openPurse)
  end
  CMUI.openPurse:setChecked(config.openPurse)
  
  -- Open Loot Bag
  CMUI.reopenAtLogin.onClick = function(widget)
    config.reopenAtLogin = not config.reopenAtLogin
    CMUI.reopenAtLogin:setChecked(config.reopenAtLogin)
  end
  CMUI.reopenAtLogin:setChecked(config.reopenAtLogin)

  -- Open Quiver
  CMUI.openQuiver.onClick = function(widget)
    config.openQuiver = not config.openQuiver
    CMUI.openQuiver:setChecked(config.openQuiver)
  end
  CMUI.openQuiver:setChecked(config.openQuiver)

  -- Refresh Sort Items Panel
  local function refreshSortList(k, t)
    t = t or {}
    UI.Container(function()
      t = CMUI.sortList:getItems()
      if k then
        config.list[k].eItems = t
      end
    end, true, nil, CMUI.sortList) 
    CMUI.sortList:setItems(t)
  end
  refreshSortList() -- create first empty panel

  -- Clear Errors
  local function clearErrors()
    CMUI.contName:setColor('white')
    CMUI.contName:setImageColor('#ffffff')
    CMUI.contId:setImageColor('#ffffff')
  end

  -- Containers List
  local refreshEntryList = function(tFocus)
    if config.list and #config.list > 0 then
      -- Clear List
      for i, child in pairs(CMUI.containerList:getChildren()) do
        child:destroy()
      end
      -- Entry List
      for e, entry in pairs(config.list) do
        -- Entry Config
        local label = g_ui.createWidget("BackpackName", CMUI.containerList)
        label.onMouseRelease = function()
          clearErrors()
          CMUI.contId:setItemId(entry.eId)
          CMUI.contName:setText(entry.eName)
          entry.eItems = entry.eItems or {}
          -- CMUI.sortList:setItems(entry.eItems)
          refreshSortList(e, entry.eItems)
        end
        -- Entry Enabled
        label.eEnabled.onClick = function(widget)
          entry.eEnabled = not entry.eEnabled
          label.eEnabled:setChecked(entry.eEnabled)
          label.eEnabled:setImageColor(entry.eEnabled and cGreen or cRed)
        end
        -- Entry Remove
        label.eRemove.onClick = function(widget)
          table.remove(config.list, e)
          label:destroy()
        end
        -- Entry Minimized
        label.eMinimize:setChecked(entry.eMinimize)
        label.eMinimize.onClick = function(widget)
          entry.eMinimize = not entry.eMinimize
          label.eMinimize:setChecked(entry.eMinimize)
          label.eMinimize:setColor(entry.eMinimize and cGreen or cRed)
        end
        -- Entry OpenNext
        label.eOpenNext.onClick = function(widget)
          entry.eOpenNext = not entry.eOpenNext
          label.eOpenNext:setChecked(entry.eOpenNext)
          label.eOpenNext:setColor(entry.eOpenNext and cGreen or cRed)
        end
        -- Entry Resize
        label.eResize.onClick = function(widget)
          entry.eResize = not entry.eResize
          label.eResize:setChecked(entry.eResize)
          label.eResize:setColor(entry.eResize and cGreen or cRed)
        end
        -- Entry Rename
        label.eRename.onClick = function(widget)
          entry.eRename = not entry.eRename
          label.eRename:setChecked(entry.eRename)
          label.eRename:setColor(entry.eRename and cGreen or cRed)
        end
        -- Entry Infinite
        label.eInfinite.onClick = function(widget)
          entry.eInfinite = not entry.eInfinite
          label.eInfinite:setChecked(entry.eInfinite)
          label.eInfinite:setColor(entry.eInfinite and cGreen or cRed)
        end
        -- Entry Open Next if Full
        label.eFull.onClick = function(widget)
          entry.eFull = not entry.eFull
          label.eFull:setChecked(entry.eFull)
          label.eFull:setColor(entry.eFull and cGreen or cRed)
        end
        -- Entry Pages
        label.ePages.onClick = function(widget)
          entry.ePages = not entry.ePages
          label.ePages:setChecked(entry.ePages)
          label.ePages:setColor(entry.ePages and cGreen or cRed)
        end
        -- Show Entry
        label:setText(entry.eName)
        label.eEnabled:setChecked(entry.eEnabled)
        label.eEnabled:setImageColor(entry.eEnabled and cGreen or cRed)
        label.eMinimize:setColor(entry.eMinimize and cGreen or cRed)
        label.eOpenNext:setColor(entry.eOpenNext and cGreen or cRed)
        label.eRename:setColor(entry.eRename and cGreen or cRed)
        label.eInfinite:setColor(entry.eInfinite and cGreen or cRed)
        label.eFull:setColor(entry.eFull and cGreen or cRed)
        label.ePages:setColor(entry.ePages and cGreen or cRed)
        label.eResize:setColor(entry.eResize and cGreen or cRed)

        -- Focus Entry
        if tFocus then
          if entry.eId == tFocus then
            CMUI.containerList:focusChild(label)
          end
        end
      end
    end
  end
  refreshEntryList()

  -- Clear Panel
  local function clearPanel()
    clearErrors()
    CMUI.contId:setItemId(0)
    CMUI.contName:setText('')
    CMUI.sortList:setItems({})
    refreshSortList()
    refreshEntryList()
  end

  -- Add New Container / Save
  CMUI.addContainer.onClick = function(widget)
    clearErrors()
    local id = CMUI.contId:getItemId()
    local name = CMUI.contName:getText()
    local items = CMUI.sortList:getItems()

    -- is valid?
    if id > 100 and name:len() > 0 then
      local index = findContainerConfig(id)
      local c = index and config.list[index] or {}
      local t = {
        eId = id,
        eName = name,
        eEnabled = c.eEnabled or true,
        eMinimize = c.eMinimize or false,
        eOpenNext = c.eOpenNext or true,
        eRename = c.eRename or true,
        eInfinite = c.eInfinite or false,
        ePages = c.ePages or false,
        eFull = c.eFull or false,
        eResize = c.eResize or true,
        eItems = c.eItems or items,
      }
      
      if index then -- update entry
        config.list[index] = t
      else -- new entry
        table.insert(config.list,t)
      end
      refreshEntryList(id)
    else
      if id <= 100 then CMUI.contId:setImageColor('red') end
      if name:len() == 0 then 
        CMUI.contName:setImageColor('red')
        CMUI.contName:setColor('red')
      end
    end
  end

  -- Clear Button
  CMUI.clear.onClick = function(widget)
    clearPanel()
  end
  
  -- On Visibility Change, we update parsed tables
  CMUI.onVisibilityChange = function(widget, visible)
    parseContainerList()
    parseSortItems()
  end
else
  warn(tag.."ERROR!")
end
-- End of UI Functions


-- Move item
local function moveItem(item, destination, index)
  local i = index or destination:getSlotPosition(destination:getItemsCount()+1)
  g_game.move(item, i, item:getCount())
end

-- Check if quiver is open
local function isMainOpened()
  local mainId = nil
  local slot = getBack()
  if slot and slot:isContainer() then
    mainId = slot:getId()
  end
  if mainId and getContainerByItem(mainId) then
    return true
  end
  return false
end

-- Check if quiver is open
local function isQuiverOpened()
  local quiverId = nil
  local t = slotsQuiver
  for i=1,#t do
    local slot = t[i]
    if slot and slot:isContainer() then
      quiverId = slot:getId()
      break
    end
  end
  if quiverId and getContainerByItem(quiverId) then
    return true
  end
  return false
end

-- Open Main Containers: Back, Purse, Bag and Quiver
local function openMain()

  -- Open Main BackPack
  if not isMainOpened() then
    g_game.use(getBack())

  -- Open Quiver
  elseif not isQuiverOpened() then
    local t = slotsQuiver
    for i=1,#t do
      local slot = t[i]
      if slot and slot:isContainer() then
        g_game.use(slot)
        break
      end
    end

  -- Open Purse
  elseif not getContainerByItem(purseId) then
    local purse = getPurse()
    if purse and purse:isContainer() then
      g_game.use(purse)
    end
  end
  
end

-- Full AFK functions
-- Check if have enough opened containers to proceed
local function checkBps(noWarn)
  if table.size(g_game.getContainers()) < config.qtdFullAfk then 
    warn(tag.."Not Enough BPs.. Retrying")
    reopenContainers()
  else
    if not noWarn then
      warn(tag.."Enough BPs: Continue")
    end
    if config.pausedCave then
      CaveBot.setOn()
      config.pausedCave = false
    end
  end
end

-- Pause CaveBot to reopen containers
local function pauseAfk()
  if CaveBot.isOn() then
    CaveBot.setOff()
    config.pausedCave = true
  end

  if TargetBot.isOn() then
    if TargetBot.isActive() then
      warn(tag.."Waiting TargetBot")
      schedule(5000, function()
        pauseAfk()
      end)
      return
    end
  end
  checkBps()
end

-- Open Next Table
local containersToOpen = {}
-- Containers with pages table
local pageContainers = {}

-- Reopen Containers (this one must be Global)
function reopenContainers()
  if cManager:isOff() then return end
  for _, cont in pairs(g_game.getContainers()) do g_game.close(cont) end
  if config.onFullAfk then 
    schedule((config.qtdFullAfk + 2) * defaultDelay, function()
      pauseAfk()
    end)
  end
  schedule(defaultDelay * 2,function()
    openMain()
  end)
end

onContainerOpen(function(container, previousContainer)
  if cManager:isOff() then return end
  if container.lootContainer then return end
  local cId = container:getContainerItem():getId()
  local index = findContainerConfig(cId)
  if not index then return end
  local settings = config.list[index]
  if not settings.eEnabled then return end

  if not container.window then return end
  local cWindow = container.window
  if settings.eResize then cWindow:setContentHeight(34) end
  if settings.eRename then cWindow:setText(settings.eName) end
  if settings.eMinimize then cWindow:minimize() end

  -- auto next page
  if settings.ePages and container:hasPages() then
    local nextPageButton = container.window:recursiveGetChildById('nextPageButton')
    if nextPageButton then 
      table.insert(pageContainers,container)
    end
  end

  if settings.eOpenNext then
    for i, item in ipairs(container:getItems()) do
      if table.find(cList,item:getId()) then
        table.insert(containersToOpen,item)
      end
    end
  end
end)

-- Containers with pages
local nextPageMacro = macro(defaultDelay * 2, function()
  if cManager:isOff() then return end
  for c, container in pairs(pageContainers) do
    if container.window and container:hasPages() then
      local nextPageButton = container.window:recursiveGetChildById('nextPageButton')
      if nextPageButton then nextPageButton.onClick() end
    else
      table.remove(pageContainers,c)
    end
  end
end)

-- Containers to be opened
local openNextMacro = macro(defaultDelay,function()
  if cManager:isOff() then return end
  local old = table.size(g_game.getContainers())
  for e, entry in pairs(containersToOpen) do
    g_game.open(entry,nil)
    table.remove(containersToOpen,e)
    return delay(defaultDelay + 5)
  end
  openMain()
end)

local sortItemsMacro = macro(defaultDelay, function(m)
  if cManager:isOn() and config.sortItems then
    if TargetBot and TargetBot.isActive() then return end
    for c, cont in pairs(g_game.getContainers()) do
      local srcId = cont:getContainerItem():getId()
      local srcIndex = findContainerConfig(srcId)
      if srcIndex then
        local srcConfig = config.list[srcIndex]
        if srcConfig and srcConfig.eEnabled then
          for i, item in ipairs(cont:getItems()) do
            local toId = sList[item:getId()]
            if toId and toId ~= srcId then
              local toIndex = findContainerConfig(toId)
              if toIndex then
                local toConfig = config.list[toIndex]
                if toConfig and toConfig.eEnabled then
                  local destNotFull = getContainerByItem(toId, not toConfig.eInfinite)
                  if destNotFull then
                    return moveItem(item,destNotFull,toConfig.eInfinite and 0 or nil)
                  elseif toConfig.eFull then
                    local destFull = getContainerByItem(toId)
                    if destFull then
                      for n, newCont in ipairs(destFull:getItems()) do
                        if newCont:getId() == toId then
                          return g_game.open(newCont,destFull)
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end)

-- Full AFK loop
macro(20000,function()
  if cManager.isOn() and config.onFullAfk then
    checkBps(true)
	  delay(config.qtdFullAfk * defaultDelay)
  end
end)

if cManager.isOn() and config.reopenAtLogin then reopenContainers() end
UI.Separator()