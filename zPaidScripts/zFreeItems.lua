-- SCRIPT MADE BY F.Almeida#8019 - if you are reading this, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

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
    !text: tr('Free Items / Bag Loot')

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
  height: 255

  Label
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 5
    text-align: center
    width: 120
    text: Max Distance:
    height: 17

  SpinBox
    id: maxPos
    height: 17
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    minimum: 1
    maximum: 5
    step: 1
    editable: true
    text-align: center

  Label
    anchors.top: prev.bottom
    margin-top: 5
    anchors.left: parent.left
    margin-top: 5
    text-align: center
    width: 120
    text: Min Capacity:
    height: 17

  BotTextEdit
    id: minCap
    height: 17
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    editable: true
    text-align: center
    text: 0.1

  Label
    anchors.top: prev.bottom
    margin-top: 5
    anchors.left: parent.left
    margin-top: 5
    text-align: center
    width: 120
    text: Move Delay:
    height: 17

  BotTextEdit
    id: moveDelay
    height: 17
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    editable: true
    text-align: center
    text: 0.1
    
  Label
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    text-align: center
    text: Items to Pick Up:

  BotContainer
    id: freeItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 35

  Label
    anchors.top: prev.bottom
    margin-top: 5
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Containers to Fill:

  BotContainer
    id: freeContainers
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 35

  BotSwitch
    id: moveBag
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 17
    text: Move Bag Loot
    tooltip: Auto move container to your feet    
  
  BotSwitch
    id: openNext
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 17
    text: Open Next Container
    tooltip: Auto open next container if container is full

  BotSwitch
    id: reopen
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 17
    text: ReOpen Container
    tooltip: Auto re-open container if its not opened yet

  BotSwitch
    id: moveTrash
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 17
    text: Throw Trash Away
    tooltip: Auto move trash away to continue looting

  BotSwitch
    id: moveOne
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 17
    text: Slow Move Items
    tooltip: Turn it on if you are having problems with the moving speed
]])
edit:hide()

if not storage.freeLoot then
    storage.freeLoot = {
      enabled = false,
      maxPos = 1,
      minCap = "0.1",
      moveDelay = "300",
      openNext = true,
      moveBag = true,
      moveTrash = true,
      moveOne = false,
      reopen = true,
      freeItems = { 3031, 3035, 3043 },
      freeContainers = {}
    }
end

local config = storage.freeLoot
config.moveDelay = config.moveDelay or "300"

local showEdit = false
ui.edit.onClick = function(widget)
  showEdit = not showEdit
  if showEdit then
    edit:show()
  else
    edit:hide()
  end
end

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
  config.enabled = not config.enabled
  ui.title:setOn(config.enabled)
end

edit.openNext:setOn(config.openNext)
edit.openNext.onClick = function(widget)
  config.openNext = not config.openNext
  edit.openNext:setOn(config.openNext)
end

edit.reopen:setOn(config.reopen)
edit.reopen.onClick = function(widget)
  config.reopen = not config.reopen
  edit.reopen:setOn(config.reopen)
end

edit.moveBag:setOn(config.moveBag)
edit.moveBag.onClick = function(widget)
  config.moveBag = not config.moveBag
  edit.moveBag:setOn(config.moveBag)
end

edit.moveTrash:setOn(config.moveTrash)
edit.moveTrash.onClick = function(widget)
  config.moveTrash = not config.moveTrash
  edit.moveTrash:setOn(config.moveTrash)
end

edit.moveOne:setOn(config.moveOne)
edit.moveOne.onClick = function(widget)
  config.moveOne = not config.moveOne
  edit.moveOne:setOn(config.moveOne)
end

edit.maxPos:setValue(config.maxPos)
edit.maxPos.onValueChange = function(widget, value)
  config.maxPos = value
end

edit.minCap:setText(config.minCap)
edit.minCap.onTextChange = function(widget, text)
  config.minCap = text
end

edit.moveDelay:setText(config.moveDelay)
edit.moveDelay.onTextChange = function(widget, text)
  config.moveDelay = text
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

UI.Container(function()
  config.freeItems = properTable(edit.freeItems:getItems())
end, true, nil, edit.freeItems) 
edit.freeItems:setItems(config.freeItems)
config.freeItems = properTable(edit.freeItems:getItems())

UI.Container(function()
  config.freeContainers = properTable(edit.freeContainers:getItems())
end, true, nil, edit.freeContainers) 
edit.freeContainers:setItems(config.freeContainers)
config.freeContainers = properTable(edit.freeContainers:getItems())

local delay = now

-- check destination and reopen container
-- "open next container" "auto reopen"
local dest = nil
macro(100,function()
  if not config.enabled or dest or delay > now then return end

  if #config.freeContainers < 1 then
    warn("[FreeItems]: You must set up\ncontainers to pick up items.")
    delay = now + 5000
    return
  end

  -- search for a destination in opened containers
  local containers = g_game.getContainers()
  for _, cont in pairs(containers) do
    local cName = cont:getName():lower()
    if table.find(config.freeContainers, cont:getContainerItem():getId()) then
      if cont:getCapacity() > #cont:getItems() then
        dest = cont
        return
        -- container is full, open next?
      elseif config.openNext then
        for i, item in pairs(cont:getItems()) do
          if item:isContainer() and (not config.freeContainers[1] or table.contains(config.freeContainers, item:getId())) then 
            g_game.open(item, cont)
            -- delay = now + exhausted
            return
          end
        end
      end
    end
  end

  -- no destination yet? should look on ground?
  if not dest and config.reopen and config.freeContainers[1] then 
    local tile = g_map.getTile(player:getPosition())
    if tile then 
      local things = tile:getThings()
      for t, thing in pairs(things) do
        if table.find(config.freeContainers,thing:getId()) then
          delay = now + tonumber(config.moveDelay)
          g_game.open(thing)
          return
        end
      end
    end
  end
  
end)

-- main function
macro(50, function()
  if not config.enabled or delay > now or TargetBot.isActive() then return end
  local exhausted = tonumber(config.moveDelay)

  -- check capacity
  if freecap() < tonumber(config.minCap) then return end

  -- wait for destination
  if not dest then return end

  -- ok, lets check around
  for x = -config.maxPos, config.maxPos do
    for y = -config.maxPos, config.maxPos do
      local pos = player:getPosition()
      local tile = g_map.getTile({x = pos.x + x, y = pos.y + y, z = pos.z})
      if tile and (x ~= 0 or y ~= 0) then
        local things = tile:getThings()
        for _, item in ipairs(things) do
          if not item:isNotMoveable() and not item:isCreature() then
            if table.find(config.freeItems, item:getId()) then
              local cap = dest:getCapacity()
              g_game.move(item,dest:getSlotPosition(cap),item:getCount())
              -- dest is full (or almost), lets break and search for another one
              if #dest:getItems() >= (cap-1) then dest = nil return end
              -- Move One Item per time
              delay = now + exhausted
              if config.moveOne then return end
            elseif table.find(config.freeContainers,item:getId()) then
              -- this container should be in your feet ^.- just break and wait
              delay = now + exhausted
              return
              --move trash?
            elseif config.moveTrash and (math.abs(x) == 1 or math.abs(y) == 1) then
              local trashTile = nil
              local d = item:isStackable() and 4 or 2
              for xp = -d,d do
                for yp = -d,d do
                  if math.abs(yp) > 1 or math.abs(xp) > 1 then
                    trashTile = g_map.getTile({x = pos.x + xp, y = pos.y + yp, z = pos.z})
                    if trashTile and not trashTile:isHouseTile() and trashTile:isWalkable() then
                      local trashPos = trashTile:getPosition()
                      local tilePos = tile:getPosition()
                      if findPath(trashPos,tilePos, 7, { ignoreNonPathable = true, precision = 1 }) and g_map.isSightClear(tilePos,trashPos) then
                        return g_game.move(item,trashPos,item:getCount())
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

-- for compat
local function getNear(pos)
  if type(pos) ~= "table" then pos = pos:getPosition() end

  local tiles = {}
  local dirs = {
      {-1, 1}, {0, 1}, {1, 1}, {-1, 0}, {1, 0}, {-1, -1}, {0, -1}, {1, -1}
  }
  for i = 1, #dirs do
      local tile = g_map.getTile({
          x = pos.x - dirs[i][1],
          y = pos.y - dirs[i][2],
          z = pos.z
      })
      if tile then table.insert(tiles, tile) end
  end

  return tiles
end

-- auto move container on ground
onPlayerPositionChange(function(newPos, oldPos)
  if not config.enabled then return true end
  dest = nil
  if not config.moveBag then return true end

  local max = config.maxPos
  local tiles = getNear(newPos)

  for t, tile in pairs(tiles) do
    if tile then
      local items = tile:getItems()
      for i, item in pairs(items) do
        if table.find(config.freeContainers,item:getId()) then
          g_game.move(item,newPos)
          return true
        end
      end
    end
  end

end)
UI.Separator()

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL