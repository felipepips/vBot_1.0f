


-- Catar itens no chão (use com moderaçao para não debugar
setDefaultTab("Main")


catarChao = macro(500, "- Catar Itens do chao -", "", function()
  if not storage.pickUp[1] then return end
  for x = -CheckPOS, CheckPOS do
    for y = -CheckPOS, CheckPOS do
    local tile = g_map.getTile({x = posx() + x, y = posy() + y, z = posz()})
      if tile then
      local things = tile:getThings()
        for a , item in pairs(things) do
          for c, catar in pairs(storage.pickUp) do
            if table.find(catar, item:getId()) then
            local containers = getContainers()
              for _, container in pairs(containers) do            
                for g, guardar in pairs(storage.containerpickUp) do
                  if table.find(guardar, container:getContainerItem():getId()) then
                    g_game.move(item, container:getSlotPosition(container:getItemsCount()), item:getCount())
                    delay(100)               
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


if type(storage.pickUp) ~= "table" then
  storage.pickUp = {3035, 3246}
end

if type(storage.containerpickUp) ~= "table" then
  storage.containerpickUp = {21411}
end

local pickUpContainer = UI.Container(function(widget, items)
  storage.pickUp = items
end, true)
pickUpContainer:setHeight(35)
pickUpContainer:setItems(storage.pickUp)

local CheckPOS = 7 -- a quantidade de SQM em volta do char que vai checar.. eu deixo 1.

UI.Label("BackPack p/ Coletar")
local containerpickUpContainer = UI.Container(function(widget, items)
  storage.containerpickUp = items
end, true)
containerpickUpContainer:setHeight(35)
containerpickUpContainer:setItems(storage.containerpickUp)


--- show cordenadas no chat
onTextMessage(function(mode, text)
    if mode == 20 and text:find("You see") then
        if not modules.game_interface.gameMapPanel.mousePos then return end
        local tile = modules.game_interface.gameMapPanel:getTile(modules.game_interface.gameMapPanel.mousePos)
        if tile then
            local loc = tile:getPosition()

            if not modules.game_textmessage then return end
            modules.game_textmessage.displayMessage(16, "position: " .. loc.x.. ", "..loc.y..", "..loc.z)
        end
    end
end)

--- click reuse


local reUseToggle = macro(1000, "Click ReUse", "`", function() end)
local excluded = {268, 237, 238, 23373, 266, 236, 239, 7643, 23375, 7642, 23374, 5908, 5942, storage.shovel, storage.rope, storage.machete} 

onUseWith(function(pos, itemId, target, subType)
  if reUseToggle.isOn() and not table.find(excluded, itemId) then
    schedule(50, function()
      item = findItem(itemId)
      if item then
        modules.game_interface.startUseWith(item)
      end
    end)
  end
end)

-- autohaste
UI.Separator()
UI.Label("Haste Spell")
UI.TextEdit(storage.hasteSpell or "exura ico", function(widget, newText)
storage.hasteSpell = newText
end)
macro(500, "haste", function()
if hasHaste() then return end
if TargetBot then
TargetBot.saySpell(storage.hasteSpell) -- sync spell with targetbot if available
else
say(storage.hasteSpell)
end
end)








-- bless

if player:getBlessings() == 0 then
    say("!bless")
    schedule(2000, function() 
        if player:getBlessings() == 0 then
            error("!! Blessings not bought !!")
        end
    end)
end





UI.Separator()
----------------------------------------------------------------------


-- summon

-- config

-- 1 - EK
-- 2 - RP
-- 3 - MS
-- 4 - ED

local vocation = player:getVocation()

-- dont edit below

local manaCost
local spellName

if vocation == 4 then  
    spellName = "utevo gran res dru"
    manaCost = 3000
elseif vocation == 3 then
    spellName = "utevo gran res ven"
    manaCost = 3000
elseif vocation == 1 then
    spellName = "utevo gran res eq"
    manaCost = 1000
elseif vocation == 2 then
    spellName = "utevo gran res sac"
    manaCost = 2000
end

macro(1000, "Auto Summon Familiar", function()
    if mana() >= manaCost and lvl() >= 200 then
        say(spellName)
        delay(19000)
    end
end)
--fast atk
UI.Separator()
macro(50, "Fast Attack", function()
  if not g_game.isAttacking() then 
    for i, spec in ipairs(getSpectators(posz())) do
      if spec:isMonster() then
        g_game.attack(spec)
        g_game.cancelAttack() 
        break
      end
    end
  end
end)

UI.Separator()
-- mw

local toggle = macro(1000, "MW qnd andar", ",",function() end)

onPlayerPositionChange(function(newPos, oldPos)
    if oldPos.z ~= posz() then return end
    if oldPos then
        local tile = g_map.getTile(oldPos)
        if toggle.isOn() and tile:isWalkable() then
            useWith(3180, tile:getTopUseThing())
            toggle.setOff()
        end
    end
end)

-- mw no target

local toggle2 = macro(1000, "MW no target", ".",function() end)

onCreaturePositionChange(function(creature, newPos, oldPos)
    if creature == target() or creature == g_game.getFollowingCreature() then
        if oldPos and oldPos.z == posz() then
            local tile2 = g_map.getTile(oldPos)
            if toggle2.isOn() and tile2:isWalkable() then
                useWith(3180, tile2:getTopUseThing())
                toggle2.setOff()
            end
        end
    end
end)


local key = "K" -- Hotkey para tacar mwall
local mwallId = 3180 -- Mwall ID
local squaresThreshold = 1 -- quantidade de sqm a tacar MW frente do char
singlehotkey(key, "Mwall Frente Target", function()
local target = g_game.getAttackingCreature()
      if target then
local targetPos = target:getPosition()
local targetDir = target:getDirection()
local mwallTile
      if targetDir == 0 then -- north
        targetPos.y = targetPos.y - squaresThreshold
        mwallTile = g_map.getTile(targetPos)
        useWith(mwallId, mwallTile:getTopUseThing())
      elseif targetDir == 1 then -- east
        targetPos.x = targetPos.x + squaresThreshold
        mwallTile = g_map.getTile(targetPos)
        useWith(mwallId, mwallTile:getTopUseThing())
      elseif targetDir == 2 then -- south
        targetPos.y = targetPos.y + squaresThreshold
        mwallTile = g_map.getTile(targetPos)
        useWith(mwallId, mwallTile:getTopUseThing())
      elseif targetDir == 3 then -- west
        targetPos.x = targetPos.x - squaresThreshold
        mwallTile = g_map.getTile(targetPos)
        useWith(mwallId, mwallTile:getTopUseThing())
      end
   end
end)


UI.Separator()
-- open bp
macro(1000, "Main BP Open", function()
    bpItem = getBack()
    bp = getContainer(0)

    if not bp and bpItem ~= nil then
        g_game.open(bpItem)
    end

end)


-- auto exeta loot
UI.Separator()
local exeta = macro(1000, "Auto Exeta Loot", function() end)

onCreatureDisappear(function(creature)
    if not creature:isMonster() then return end
    local pos = creature:getPosition()
    if pos.z ~= posz() then return end

    local tile = g_map.getTile(pos)
    if not tile then return end
    local tilePos = tile:getPosition()
    local pPos = player:getPosition()

    if math.abs(pPos.x-tilePos.x) >= 5 or math.abs(pPos.y-tilePos.y) >= 5 then return end -- change the range to your needs: 5 sqm
    if exeta.isOn() and getMonsters(1) == 0 then
        say("exeta loot")
        -- CaveBot.delay(600)
        delay(500)
        return
    end

end)


-- auto follow
UI.Label("Auto Follow")

local followThis = tostring(storage.followLeader)

-- incluir abaixo IDs que estejam bugando
FloorChangers = {
    Ladders = {
        Up = {1948, 5542, 16693, 16692, 8065, 8263, 7771},
        Down = {432, 412, 469, 1949, 469, 1080}
    },

    Holes = {
        Up = {},
        Down = {293, 294, 595, 1949, 4728, 385, 9853, 37000, 37001, 35499, 35497, 25050, 29979, 25047, 25048, 25049, 25050, 
                25051, 25052, 25053, 25054, 25055, 25056, 25057, 25058 }
    },

    RopeSpots = {
        Up = {386, 12202, 21965},
        Down = {}
    },

    Stairs = {
        Up = {16690, 1958, 7548, 7544, 1952, 1950, 1947, 7542, 855, 856, 1978, 1977, 6911, 6915, 1954, 5259, 20492, 1956, 775,
              5257, 5258, 25058, 22566, 22747, 30757, 20225, 17395, 1964, 1966, 20255, 29113, 28357, 30912, 30906, 30908, 30914, 
              30916, 30904, 30918 },

        Down = {482, 414, 413, 437, 7731, 469, 413, 434, 469, 859, 438, 6127, 566, 7476, 4826, 484, 433, 369, 20259, 19960, 411,
                8690, 4825, 6130, 601}
    },

    Sewers = {
        Up = {},
        Down = {435}
    },
}

local target = followThis
local lastKnownPosition

local function goLastKnown()
    if getDistanceBetween(pos(), {x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z}) > 1 then
        local newTile = g_map.getTile({x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z})
        if newTile then
            g_game.use(newTile:getTopUseThing())
            delay(math.random(300, 700))
        end
    end
end

local function handleUse(pos)
    goLastKnown()
    local lastZ = posz()
    if posz() == lastZ then
        local newTile = g_map.getTile({x = pos.x, y = pos.y, z = pos.z})
        if newTile then
            g_game.use(newTile:getTopUseThing())
            delay(math.random(400, 800))
        end
    end
end

local function handleStep(pos)
    goLastKnown()
    local lastZ = posz()
    if posz() == lastZ then
        autoWalk(pos)
        delay(math.random(400, 800))
    end
end

local function handleRope(pos)
    goLastKnown()
    local lastZ = posz()
    if posz() == lastZ then
        local newTile = g_map.getTile({x = pos.x, y = pos.y, z = pos.z})
        if newTile then
            useWith(3003, newTile:getTopUseThing())
            delay(math.random(400, 800))
        end
    end
end

local floorChangeSelector = {
    Ladders = {Up = handleUse, Down = handleStep},
    Holes = {Up = handleStep, Down = handleStep},
    RopeSpots = {Up = handleRope, Down = handleRope},
    Stairs = {Up = handleStep, Down = handleStep},
    Sewers = {Up = handleUse, Down = handleUse},
}

local function checkTargetPos()
    local c = getCreatureByName(target)
    if c and c:getPosition().z == posz() then
        lastKnownPosition = c:getPosition()
    end
end

local function distance(pos1, pos2)
    local pos2 = pos2 or lastKnownPosition or pos()
    return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

local function executeClosest(possibilities)
    local closest
    local closestDistance = 99999
    for _, data in ipairs(possibilities) do
        local dist = distance(data.pos)
        if dist < closestDistance then
            closest = data
            closestDistance = dist
        end
    end

    if closest then
        closest.changer(closest.pos)
    end
end

local function handleFloorChange()
    local c = getCreatureByName(target)
    local range = 2
    local p = pos()
    local possibleChangers = {}
    for _, dir in ipairs({"Down", "Up"}) do
        for changer, data in pairs(FloorChangers) do
            for x = -range, range do
                for y = -range, range do
                    local tile = g_map.getTile({x = p.x + x, y = p.y + y, z = p.z})
                    if tile then
                        if table.find(data[dir], tile:getTopUseThing():getId()) then
                            table.insert(possibleChangers, {changer = floorChangeSelector[changer][dir], pos = {x = p.x + x, y = p.y + y, z = p.z}})
                        end
                    end
                end
            end
        end
    end
    executeClosest(possibleChangers)
end

local function targetMissing()
    for _, n in ipairs(getSpectators(false)) do
        if n:getName() == target then
            return n:getPosition().z ~= posz()
        end
    end
    return true
end

macro(500, "Advanced Follow", "", function(macro)
    local c = getCreatureByName(target)

    if g_game.isFollowing() then
        if g_game.getFollowingCreature() ~= c then
            g_game.cancelFollow()
            g_game.follow(c)
        end
    end

    if c and not g_game.isFollowing() then
        g_game.follow(c)
    elseif c and g_game.isFollowing() and getDistanceBetween(pos(), c:getPosition()) > 1 then
        g_game.cancelFollow()
        g_game.follow(c)
    end

    checkTargetPos()
    if targetMissing() and lastKnownPosition then
        handleFloorChange()
    end
end)

UI.Label("Follow Player:")
addTextEdit("playerToFollow", storage.followLeader or "Nome do player", function(widget, text)
    storage.followLeader = text
    target = tostring(text)
end)
---------------------------------------------------------





UI.Separator()
UI.Separator()



shotdown = UI.Button("Force LOGOUT", function()
        g_game.forceLogout()
        shotdown.setOff()
		end)
UI.Separator()
UI.Separator()



setDefaultTab("Tools")

macro(100, "UH Friend", function()
  for _, creature in pairs(getSpectators(posz())) do
    local heal_player = creature:getName();
    if (heal_player == storage.uhFriend) then
      if (creature:getHealthPercent() < tonumber(storage.uhFriendPercent)) then
        useWith(3160, creature);
        return;
      end
    end
  end
end)
addLabel("uhname", "Player Name:")
addTextEdit("uhfriend", storage.uhFriend or "", function(widget, text)    
  storage.uhFriend = text
end) 
addLabel("uhpercent", "Porcentagem HP %:")
addTextEdit("uhfriendpercent", storage.uhFriendPercent or "", function(widget, text)    
  storage.uhFriendPercent = text
end)

-- bugmaps
-- mais rápido do que os convencionais que usam onKeyPress()
local function checkPos(x, y)
 xyz = g_game.getLocalPlayer():getPosition()
 xyz.x = xyz.x + x
 xyz.y = xyz.y + y
 tile = g_map.getTile(xyz)
 if tile then
  return g_game.use(tile:getTopUseThing())  
 else
  return false
 end
end
--


macro(1, 'Bug Map', function() 
 if modules.corelib.g_keyboard.isKeyPressed('w') then
  checkPos(0, -5)
 elseif modules.corelib.g_keyboard.isKeyPressed('e') then
  checkPos(3, -3)
 elseif modules.corelib.g_keyboard.isKeyPressed('d') then
  checkPos(5, 0)
 elseif modules.corelib.g_keyboard.isKeyPressed('c') then
  checkPos(3, 3)
 elseif modules.corelib.g_keyboard.isKeyPressed('s') then
  checkPos(0, 5)
 elseif modules.corelib.g_keyboard.isKeyPressed('z') then
  checkPos(-3, 3)
 elseif modules.corelib.g_keyboard.isKeyPressed('a') then
  checkPos(-5, 0)
 elseif modules.corelib.g_keyboard.isKeyPressed('q') then
  checkPos(-3, -3)
 end
end)


UI.Separator()

--
mwTarget = macro(200, "- MW no Mouse - HK M", "M", function() 
    local tile = getTileUnderCursor()
    if not tile then return end
    g_game.useInventoryItemWith(3180, tile:getTopUseThing())
end)

macro(250, "Dance", function()

    turn(math.random(0, 4)) -- turn to a random direction.

 end, warTab)
 
 

UI.Separator()
macro(250, "Catar itens do pe", function()
  local tile = g_map.getTile(pos())
  if tile then
    for _, item in ipairs(tile:getItems()) do
      if item:isPickupable() then
        if g_game.move(item, {x=65535, y=SlotBack, z=0}, item:getCount()) then
          delay(100)
        end
      end
    end
  end
end)
UI.Label("-- [[ ANTI PUSH Panel ]] --")
addSeparator()
  local panelName = "castle"
  local ui = setupUI([[
Panel
  height: 40

  BotItem
    id: item
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 2
    
  BotSwitch
    id: skip
    anchors.top: parent.top
    anchors.left: item.right
    anchors.right: parent.right
    anchors.bottom: item.verticalCenter
    text-align: center
    !text: tr('N jogar onde tem player')
    margin-left: 2

  BotSwitch
    id: title
    anchors.top: item.verticalCenter
    anchors.left: item.right
    anchors.right: parent.right
    anchors.bottom: item.bottom
    text-align: center
    !text: tr('Jogar flores em vota')
    margin-left: 2
      
  ]], parent)
  ui:setId(panelName)

  if not storage[panelName] then
    storage[panelName] = {
        id = 2983,
        around = false,
        enabled = false
    }
  end

  ui.skip:setOn(storage[panelName].around)
  ui.skip.onClick = function(widget)
    storage[panelName].around = not storage[panelName].around
    widget:setOn(storage[panelName].around)
  end
  ui.title:setOn(storage[panelName].enabled)
  ui.title.onClick = function(widget)
    storage[panelName].enabled = not storage[panelName].enabled
    widget:setOn(storage[panelName].enabled)
  end

  ui.item:setItemId(storage[panelName].id)
  ui.item.onItemChange = function(widget)
    storage[panelName].id = widget:getItemId()
  end


macro(175, function() 
    if storage[panelName].enabled then
        local blockItem = findItem(storage[panelName].id)
        for _, tile in pairs(g_map.getTiles(posz())) do
            if distanceFromPlayer(tile:getPosition()) == 1 and tile:isWalkable() and tile:getTopUseThing():getId() ~= storage[panelName].id and (not storage[panelName].around or not target() or (target() and getDistanceBetween(targetPos(), tile:getPosition() > 1))) then
                g_game.move(blockItem, tile:getPosition())
                return
            end
        end
        storage[panelName].enabled = false
        ui.title:setOn(storage[panelName].enabled)
    end
end)
addSeparator()

AntiPush = function(parent)
  if not parent then
    parent = panel
  end
  
  local panelName = "antiPushPanel"  
  local ui = g_ui.createWidget("ItemsPanel", parent)
  ui:setId(panelName)

  if not storage[panelName] then
    storage[panelName] = {}
  end

  ui.title:setText("Anti-Push Items")
  ui.title:setOn(storage[panelName].enabled)
  ui.title.onClick = function(widget)
    storage[panelName].enabled = not storage[panelName].enabled
    widget:setOn(storage[panelName].enabled)
  end
  
  if type(storage[panelName].items) ~= 'table' then
    storage[panelName].items = {3031, 3035, 0, 0, 0}
  end

  for i=1,5 do
    ui.items:getChildByIndex(i).onItemChange = function(widget)
      storage[panelName].items[i] = widget:getItemId()
    end
    ui.items:getChildByIndex(i):setItemId(storage[panelName].items[i])    
  end
  
  macro(10, function()    
    if not storage[panelName].enabled then
      return
    end
    local tile = g_map.getTile(player:getPosition())
    if not tile then
      return
    end
    local topItem = tile:getTopUseThing()
    if topItem and topItem:isStackable() then
      topItem = topItem:getId()
    else
      topItem = 0    
    end
    local candidates = {}
    for i, item in pairs(storage[panelName].items) do
      if item >= 10 and item ~= topItem and findItem(item) then
        table.insert(candidates, item)
      end
    end
    if #candidates == 0 then
      return
    end
    if type(storage[panelName].lastItem) ~= 'number' or storage[panelName].lastItem > #candidates then
      storage[panelName].lastItem = 1
    end
    local item = findItem(candidates[storage[panelName].lastItem])
    g_game.move(item, player:getPosition(), 1)
    storage[panelName].lastItem = storage[panelName].lastItem + 1
  end)

  macro(175, "Puxar itens pra baixo", function()
    local trashitem = nil
    for _, tile in pairs(g_map.getTiles(posz())) do
        if distanceFromPlayer(tile:getPosition()) == 1 and #tile:getItems() ~= 0 and not tile:getTopUseThing():isNotMoveable() then
            trashitem = tile:getTopUseThing()
            g_game.move(trashitem, pos(), trashitem:getCount())
            return
        end
    end
  end)
end
--


function push(x, y, z)
    local position = player:getPosition()
    position.x = position.x + x
    position.y = position.y + y
  
    local tile = g_map.getTile(position)
    local thing = tile:getTopThing()
    if thing and thing:isItem() then
      g_game.move(thing, player:getPosition(), thing:getCount())
    end
end
UI.Separator()


AntiPush(setDefaultTab("Tools"))



-- buff


--setDefaultTab("Tools")
local buffCastPanelName = "iBuffPanel"
if not storage[buffCastPanelName] then
    storage[buffCastPanelName] = {
        granBlessType = "Sorcerer",
        vocId = 1,
        blessType = false,
        recovery = false,
        party = false,
        utito = false,
    }
end

local buff_data = {
    [1] = { -- sorc
        utito = "magic",
        recovery = "mage",
        party = "utori",
    },
    [2] = { -- druid
        utito = "magic",
        recovery = "mana",
        party = "utura",
    },
    [3] = { -- paladin
        utito = "tempo san",
        recovery = "divine",
        party = "utamo",
    },
    [4] = { -- knight
        utito = "tempo",
        recovery = "exura",
        party = "utito",
    },
}

local buffCast = setupUI([[
GranBlessComboBoxPopupMenu < ComboBoxPopupMenu
GranBlessComboBoxPopupMenuButton < ComboBoxPopupMenuButton
GranBlessComboBox < ComboBox
  @onSetup: |
    self:addOption("Sorcerer", 1)
    self:addOption("Druid", 2)
    self:addOption("Paladin", 3)
    self:addOption("Knight", 4)

Panel
  height: 130
  padding-top: 5

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: parent.top
    margin-bottom: 6

  Label
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: prev.bottom
    text: Buffs
    text-align: center
    margin-top: 6

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-top: 3
    margin-bottom: 6

  GranBlessComboBox
    id: GranBlessType
    anchors.top: prev.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: 6
    margin-left: 5
    margin-right: 5

  BotSwitch
    id: utitoSwitch
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-top: 4
    margin-left: 5
    margin-right: 5
    width: 110
    height: 18
    !text: tr('Utito')

  BotSwitch
    id: recSwitch
    anchors.top: prev.bottom
    anchors.left: parent.left
    text-align: center
    margin-top: 4
    margin-right: 3
    margin-left: 5
    width: 110
    height: 18
    !text: tr('Recovery')

  CheckBox
    id: BlessType
    !text: tr('Gran')
    anchors.top: recSwitch.top
    anchors.right: parent.right
    margin-top: 4
    margin-left: 5
    margin-right: 5
    color: #ffaa00
    width: 46

  BotSwitch
    id: partySwitch
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-top: 6
    margin-left: 5
    margin-right: 5
    width: 110
    height: 18
    !text: tr('Party Buff')

  HorizontalSeparator
    id: separator1
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-top: 6
    margin-bottom: 6
  ]])

local utito_type = buff_data[storage[buffCastPanelName].vocId].utito
local recovery_type = buff_data[storage[buffCastPanelName].vocId].recovery
local party_type = buff_data[storage[buffCastPanelName].vocId].party

buffCast.GranBlessType:setOption(storage[buffCastPanelName].granBlessType)
buffCast.GranBlessType.onOptionChange = function(widget)
    storage[buffCastPanelName].granBlessType = widget:getCurrentOption().text
    storage[buffCastPanelName].vocId = widget:getCurrentOption().data
    utito_type = buff_data[storage[buffCastPanelName].vocId].utito
    recovery_type = buff_data[storage[buffCastPanelName].vocId].recovery
    party_type = buff_data[storage[buffCastPanelName].vocId].party
end

buffCast.BlessType:setChecked(storage[buffCastPanelName].blessType)
buffCast.BlessType.onClick = function(widget)
    storage[buffCastPanelName].blessType = not storage[buffCastPanelName].blessType
    widget:setChecked(storage[buffCastPanelName].blessType)
end

buffCast.recSwitch:setOn(storage[buffCastPanelName].recovery)
buffCast.recSwitch.onClick = function(widget)
    storage[buffCastPanelName].recovery = not storage[buffCastPanelName].recovery
    widget:setOn(storage[buffCastPanelName].recovery)
end
buffCast.partySwitch:setOn(storage[buffCastPanelName].party)
buffCast.partySwitch.onClick = function(widget)
    storage[buffCastPanelName].party = not storage[buffCastPanelName].party
    widget:setOn(storage[buffCastPanelName].party)
end
buffCast.utitoSwitch:setOn(storage[buffCastPanelName].utito)
buffCast.utitoSwitch.onClick = function(widget)
    storage[buffCastPanelName].utito = not storage[buffCastPanelName].utito
    widget:setOn(storage[buffCastPanelName].utito)
end

function spellcast(spell)
    if TargetBot then
        TargetBot.saySpell(spell)
    else
        say(spell)
    end
end

utitoCast = macro(9000, function()
    if isInPz() or not storage[buffCastPanelName].utito then return end
    spellcast("utito " .. utito_type)
end)
recoveryCast = macro(14000, function()
    if isInPz() or not storage[buffCastPanelName].recovery then return end
    spellcast(recovery_type .. (storage[buffCastPanelName].blessType and " gran" or '') .. ' bless "' .. name())
end)

partyCast = macro(100, function()
    if isInPz() or not storage[buffCastPanelName].party or not player:isPartyMember() then return end
    spellcast(party_type .. ' mas sio')
    delay(120000)
end)

-- auto pt



--- auto party



UI.Label("Auto Party")


local infoTime = 0

local talkTime = 0

local maxLevel = 0

local minLevel = 0

local justForInfo = true

local canSeeInfo = true

local partyMembersCount = 0



local partyLeaderHuntWidget = macro(1000, "Party Leader Hunt", function()

  if not player:isPartyLeader() then

    justForInfo = true

    partyMembersCount = 0

    return

  end

  if justForInfo and canSeeInfo then

    sayChannel(getChannelId("party"), "!party info")

    return

  end

  if talkTime > 0 then

    talkTime = talkTime - 1

  end

  if player:getShield() == 10 then

    infoTime = infoTime + 1

    if infoTime >= 20 then

      sayChannel(getChannelId("party"), "!party info")

      infoTime = 0

    end

  else

    infoTime = 0

  end

end)



addLabel("maxLevel", "Max Level:")

addTextEdit("maxLevel", storage.maxLevel or "", function(widget, text)

  if tonumber(text) then

    maxLevel = tonumber(text)

  else

    sayChannel(getChannelId("party"), "!party info")

  end

  storage.maxLevel = tonumber(text)

end)



addLabel("minLevel", "Min Level:")

addTextEdit("minLevel", storage.minLevel or "", function(widget, text)

  if tonumber(text) then

    minLevel = tonumber(text)

  else

    sayChannel(getChannelId("party"), "!party info")

  end

  storage.minLevel = tonumber(text)

end)



onTalk(function(name, level, mode, text, channelId, pos)

  if partyLeaderHuntWidget:isOn() then

    if name == player:getName() then return end

    if text:lower():find("pt") or (text:lower():find("party") and not text:lower():find("!party")) then

      for _, spec in ipairs(getSpectators()) do

        if spec:getName() == name then

          if spec:isPartyMember() then return end

          if spec:getShield() == 2 then

            g_game.talkPrivate(5, name, name .. ", I already invited you")

            return

          end

          if level > maxLevel or level < minLevel then

            g_game.talkPrivate(5, name, name .. ", the minimum level is " .. minLevel .. " and the maximum is " .. maxLevel)

            return

          end

          if partyMembersCount >= 30 then

            g_game.talkPrivate(5, name, name .. ", the party already has 30 players for a better use of the shared experience.")

            return

          end

          g_game.partyInvite(spec:getId())

        end

      end

    end

  end

end)



onLoginAdvice(function(text)

  if partyLeaderHuntWidget:isOn() then

    local explode1 = string.explode(text, "*")

    local explode2 = string.explode(explode1[8], ":")[2]

    if not storage.maxLevel then

      maxLevel = math.ceil(tonumber(string.explode(explode1[4], ":")[2])*3/2)

    else

      maxLevel = storage.maxLevel

    end

    if not storage.minLevel then

      minLevel = math.ceil(tonumber(string.explode(explode1[3], ":")[2])*2/3)

    else

      minLevel = storage.minLevel

    end

    partyMembersCount = tonumber(string.explode(explode1[2], ":")[2])

    if justForInfo then

      justForInfo = false

      return

    end

    if explode2:find(",") then

      local names = string.explode(explode2, ",")

      for i = 1, #names do

        canSeeInfo = false

        schedule(1000 * i, function()

          if i == #names then

            canSeeInfo = true

          end

          sayChannel(getChannelId("party"), "!party kick," .. names[i])

        end)

      end

    elseif explode2 ~= "" then

      schedule(1000, function() sayChannel(getChannelId("party"), "!party kick," .. explode2) end)

    end

  end

end)



onCreatureAppear(function(creature)

  if partyLeaderHuntWidget:isOn() then

    if not creature:isPlayer() then return end

    if creature:isLocalPlayer() then return end

    if creature:getShield() == 2 then return end

    if creature:isPartyMember() then return end

    if talkTime == 0 and partyMembersCount < 30 then

      say("If you want to join the party, say 'pt' so I can invite you")

      talkTime = 15

    end

  end

end)



onTextMessage(function(mode, text)

  if partyLeaderHuntWidget:isOn() then

    if text:lower():find("you are now the leader of the party.") or text:lower():find("has joined the party.") or (text:lower():find("has left the party.") and canSeeInfo) then

      justForInfo = true

    end

  end

end) 



UI.Separator()


setDefaultTab("HP")
UI.Label("PAINEL DE CURA ANTIGO")

if type(storage.healing1) ~= "table" then
  storage.healing1 = {on=false, title="HP%", text="exura", min=51, max=90}
end
if type(storage.healing2) ~= "table" then
  storage.healing2 = {on=false, title="HP%", text="exura vita", min=0, max=50}
end

-- create 2 healing widgets
for _, healingInfo in ipairs({storage.healing1, storage.healing2}) do
  local healingmacro = macro(20, function()
    local hp = player:getHealthPercent()
    if healingInfo.max >= hp and hp >= healingInfo.min then
      if TargetBot then 
        TargetBot.saySpell(healingInfo.text) -- sync spell with targetbot if available
      else
        say(healingInfo.text)
      end
    end
  end)
  healingmacro.setOn(healingInfo.on)

  UI.DualScrollPanel(healingInfo, function(widget, newParams) 
    healingInfo = newParams
    healingmacro.setOn(healingInfo.on)
  end)
end

UI.Separator()

UI.Label("Mana & health potions/runes")

if type(storage.hpitem1) ~= "table" then
  storage.hpitem1 = {on=false, title="HP%", item=266, min=51, max=90}
end
if type(storage.hpitem2) ~= "table" then
  storage.hpitem2 = {on=false, title="HP%", item=3160, min=0, max=50}
end
if type(storage.manaitem1) ~= "table" then
  storage.manaitem1 = {on=false, title="MP%", item=268, min=51, max=90}
end
if type(storage.manaitem2) ~= "table" then
  storage.manaitem2 = {on=false, title="MP%", item=3184, min=0, max=50}
end

for i, healingInfo in ipairs({storage.hpitem2, storage.manaitem2}) do
  local healingmacro = macro(20, function()
    local hp = i <= 2 and player:getHealthPercent() or math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
    if healingInfo.max >= hp and hp >= healingInfo.min then
      if TargetBot then 
        TargetBot.useItem(healingInfo.item, healingInfo.subType, player) -- sync spell with targetbot if available
      else
        local thing = g_things.getThingType(healingInfo.item)
        local subType = g_game.getClientVersion() >= 860 and 0 or 1
        if thing and thing:isFluidContainer() then
          subType = healingInfo.subType
        end
        g_game.useInventoryItemWith(healingInfo.item, player, subType)
      end
    end
  end)
  healingmacro.setOn(healingInfo.on)

  UI.DualScrollItemPanel(healingInfo, function(widget, newParams) 
    healingInfo = newParams
    healingmacro.setOn(healingInfo.on and healingInfo.item > 100)
  end)
end

if g_game.getClientVersion() < 780 then
  UI.Label("In old tibia potions & runes work only when you have backpack with them opened")
end



UI.Separator()
-----------
setDefaultTab("Target")

local DELAY = 1000 -- interval beetween spells                  |
local DISTANCE = 5 -- The distance of the player from the mobs  C
local ABOVE_MONSTER = 2 -- above the number of monsters         F
--                                                              G
local spells = {"exori gran", "exori"} -- SPELLS   |
-----------------------------------------------------------------

local function castSpells()
  for i = 1, #spells do
    schedule(DELAY*(i-1), function()
      say(spells[i])
    end)
  end
end

macro(100, "Combo Exori PVP", function()
  if not g_game.isAttacking() then return end
    
  --if getMonsters(DISTANCE, false) >= ABOVE_MONSTER and getPlayers(10, false) == 0 then
    castSpells()
 -- end
end)

UI.Separator()
macro(250, "Atacar Seguindo", function()
   if g_game.isOnline() then
         g_game.setChaseMode(1)
           end
           end)