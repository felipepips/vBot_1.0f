-- MACRO PARA FICAR "VARRENDO" O DEPOT EM BUSCA DE ITENS.. DEVE SER USADO JUNTO COM O CAVEBOT, RODANDO PELO DEPOT E EXECUTANDO A FUNCTION QUE ESTÁ NESSA PASTA

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

-- START CONFIG
setDefaultTab("Cave")
-- MAIN SETTINGS
local default_delay = 350
local precision = 0
local max_distance = 7
local min_cap = 400
-- IDS
local bagloot_id = 9602
local trash_bin_id = 2526
local transform_ids = {1633} -- open doors
local transform_to = 3681
local ignoreContainers = {"locker","depot"}
-- END CONFIG

if not storage.CleanDepot then
  storage.CleanDepot = {
    enabled = false,
    trashItems = {2853,3503,3504,3505,3506,3507},
    depotSqms = {408,429},
    nonMove = {2987},
  }
end
local config = storage.CleanDepot
config.bagloot_id = bagloot_id
config.trash_bin_id = trash_bin_id

local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 140
    !text: tr('Clean Depot')

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
  height: 180
    
  Label
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Trash:

  BotContainer
    id: trashItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 70

  Label
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Allowed Sqms:

  BotContainer
    id: depotSqms
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 35

  Label
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Ignore Non-Moveable:

  BotContainer
    id: nonMove
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 35
]])
edit:hide()

local showEdit = false
ui.edit.onClick = function(widget)
  showEdit = not showEdit
  if showEdit then edit:show()
  else edit:hide()
  end
end

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
  config.enabled = not config.enabled
  ui.title:setOn(config.enabled)
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
  config.trashItems = properTable(edit.trashItems:getItems())
end, true, nil, edit.trashItems)
edit.trashItems:setItems(config.trashItems)
config.trashItems = properTable(edit.trashItems:getItems())

UI.Container(function()
  config.depotSqms = properTable(edit.depotSqms:getItems())
end, true, nil, edit.depotSqms) 
edit.depotSqms:setItems(config.depotSqms)
config.depotSqms = properTable(edit.depotSqms:getItems())

UI.Container(function()
  config.nonMove = properTable(edit.nonMove:getItems())
end, true, nil, edit.nonMove)
edit.nonMove:setItems(config.nonMove)
config.nonMove = properTable(edit.nonMove:getItems())

-- find string fragment in table
local function findFragment(table, fragment)
  fragment = fragment:lower()
  for k,v in pairs(table) do
    if string.find(fragment,v:lower()) then
      return true
    end
  end
end

local lastCont
cleanDepotMacro = macro(default_delay,function() 
  if not config.enabled then return end
  if freecap() < min_cap then return end
  local dest = getContainerByItem(bagloot_id,true)
  if not dest then return end
  
  local pos = pos()
  for x = -max_distance, max_distance do
    for y = -max_distance, max_distance do
      local pos = player:getPosition()
      local tile = g_map.getTile({x = pos.x + x, y = pos.y + y, z = pos.z})
      if tile and (x ~= 0 or y ~= 0) and tile:getGround() then
        if table.find(config.depotSqms,tile:getGround():getId()) and not tile:isHouseTile() then
          local top = tile:getTopUseThing()
          if top and not top:isNotMoveable() and not table.find(config.nonMove,top:getId()) then
            local tPos = tile:getPosition()
            local path = findPath(pos,tPos,max_distance, {precision = precision})
            if path then
              local wait = (#path * default_delay) + (default_delay * 2)
              CaveBot.delay(wait + (default_delay * 5))
              player:stopAutoWalk()
              g_game.stop()
              if top:isContainer() then
                g_game.use(top)
                lastCont = top
              else
                g_game.move(top,dest:getSlotPosition(dest:getItemsCount()),top:getCount())
              end
              return delay(wait)
            end
          end
        end
      end
    end
  end
end)

onContainerOpen(function(container,prev)
  if not config.enabled then return end
  if freecap() < min_cap then return end
  if container:getContainerItem():getId() == bagloot_id then return end
  if findFragment(ignoreContainers,container:getName()) then return end
  if not getContainerByItem(bagloot_id,true) then return end
  local checkDest = getContainerByItem(bagloot_id,true)
  if not checkDest then return end
  local scTime = default_delay
  -- move items from inside container
  for i, item in ipairs(container:getItems()) do
    if item:isContainer() or not table.find(config.trashItems,item:getId()) then
      schedule(scTime,function()
        if not config.enabled then return end
        if item:isContainer() then
          g_game.move(item,pos(),item:getCount())
        else
          local dest = getContainerByItem(bagloot_id,true)
          if dest then
            g_game.move(item,dest:getSlotPosition(dest:getItemsCount()),item:getCount())
          end
        end
      end)
      scTime = scTime + default_delay
    end
  end
  -- take empty container and close it
  schedule(scTime + (default_delay * 2),function()
    if not config.enabled then return end
    g_game.close(container)
    if not lastCont then return end
    local dest = getContainerByItem(bagloot_id,true)
    if not dest then return end
    g_game.move(lastCont,dest:getSlotPosition(dest:getItemsCount()))
    lastCont = nil
  end)

  local pauseTime = scTime + (default_delay * 6)
  cleanDepotMacro.delay = now + pauseTime
  CaveBot.delay(pauseTime)
end)

-- Transform Doors
onAddThing(function(tile, thing)
  if not config.enabled then return end
  if not table.find(transform_ids,thing:getId()) then return end
  thing:setId(transform_to)
end)

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL