
setDefaultTab("Tools")
UI.Separator()

local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Anti-Push')

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
  height: 50
    
  Label
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    text-align: center
    text: Stack Items:

  BotContainer
    id: pushItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32
]])
edit:hide()

if not storage.antiPush then
    storage.antiPush = {
      enabled = false,
      pushItems = { 3031, 3447, 3492 },
    }
end

local config = storage.antiPush

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

UI.Container(function()
    config.pushItems = edit.pushItems:getItems()
    end, true, nil, edit.pushItems) 
edit.pushItems:setItems(config.pushItems)


local antiPush = macro(100, function()
  if not config.enabled then return end

  local pos = player:getPosition()
  local tile = g_map.getTile(pos)

  if #tile:getItems() > 7 then return true end

  local topItem = tile:getTopUseThing():getId()

  for i, item in pairs(config.pushItems) do
    local drop = findItem(item.id)
    if drop and item.id ~= topItem then
      return g_game.move(drop,pos,1)
    end
  end

end)

local trashAway = macro(1*60*1000, "Throw Trash Away", function()
end)

local dest = nil
local takeBack = macro(100,"Take Back Items", function()
  local pos = player:getPosition()
  local nearTiles = getNearTiles(pos)
  local pushItems = {}

  for e, entry in pairs(config.pushItems) do
    table.insert(pushItems,entry.id)
  end

  for t, tile in pairs(nearTiles) do
    local item = tile:getTopUseThing()
    if not item:isNotMoveable() then
      if table.find(pushItems,item:getId()) then
        if not dest then
          local containers = g_game.getContainers()
          for c, cont in pairs(containers) do
            if cont:getCapacity() > #cont:getItems() then 
              dest = cont
              break
            end
          end
        else
          g_game.move(item,dest:getSlotPosition(dest:getCapacity()),item:getCount())
          if dest:getCapacity() == #dest:getItems() then dest = nil end
          return true
        end
      elseif trashAway:isOn() then
        local trashTile = nil
        local d = item:isStackable() and 4 or 2
        for xp = -d,d do
          for yp = -d,d do
            if math.abs(yp) > 1 or math.abs(xp) > 1 then
              trashTile = g_map.getTile({x = pos.x + xp, y = pos.y + yp, z = pos.z})
              if trashTile and trashTile ~= tile and not trashTile:isHouseTile() and trashTile:canShoot() and trashTile:isWalkable() then
                local trashPos = trashTile:getPosition()
                local tilePos = tile:getPosition()
                if findPath(trashPos,tilePos, 7, { ignoreNonPathable = true, precision = 1 }) and g_map.isSightClear(tilePos,trashPos) then
                  g_game.move(item,trashPos,item:getCount())
                end
              end
            end
          end
        end
      end
    end
  end

end)

UI.Separator()