setDefaultTab("Suport")

----- TEM QUE ESTAR COM CHECKPLAYER LIGADO -----
----- "HOLD FLOWER MW" PRECISA ESTAR LIGADO PARA FUNCIONA -----
----- SE NÃO QUISER USAR O "MW NO MOUSE", DEIXE EM BRANCO -----
----- HOTKEYS DO "HOLD FLOWER MW" É A MESMA DO HOLD MW DO BOT -----

if not storage.extras then 
storage.extras = { }
end

---------------------------- FECHAR CAST

closecast = macro(5000, "Close cast", function()
  if getChannelId("live cast chat") then
    delay(1000)
    modules.game_console.removeTab("live cast chat")
    delay(1000)
  end
end)

---------------------------- mostra a posições X/Y/Z no server log, onde tu der look

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

---------------------------- ANTI PUSH

local dropItems = { 3492, 3590, 3031 }
local maxStackedItems = 5
local dropDelay = 10

addIcon("AntiPush", {item={id=3031,count=100}, movable=true, hotkey="Insert", text="AntiPush"},
macro(dropDelay , "", function()
  local tile = g_map.getTile(pos())
  if tile and tile:getThingCount() < maxStackedItems then
    local thing = tile:getTopThing()
    if thing and not thing:isNotMoveable() then
      for i, item in pairs(dropItems) do
        if item ~= thing:getId() then
            local dropItem = findItem(item)
            if dropItem then
              g_game.move(dropItem, pos(), 1)
            end
        end
      end
    end
  end
end))

---------------------------- PUSH TRASH NO PÉ


gpPushDelay = 200 -- safe value: 600ms

macro(gpPushDelay, "Puxar Trash", "End", function()
        push(0, -1, 0)
        push(0, 1, 0)
        push(-1, -1, 0)
        push(-1, 0, 0)
        push(-1, 1, 0)
        push(1, -1, 0)
        push(1, 0, 0)
        push(1, 1, 0)
end)

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

---------------------------- MW NO PÉ

local toggle = macro(10, "Mwall Step", "F12",function() end) -- taca mw no sqm anterior

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

---------------------------- MW NO PÉ DO TARGET

local toggle2 = macro(10, "MW Target Step", "F11", function() end) -- taca mw no sqm onde o alvo esta

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

---------------------------- JOGAR FLOR DO KOVEIRO

local flowerHot
local hold = 0
local candidates = {}

local m = macro(20, "Hold Flower MW", function()
if #candidates == 0 then return end
 for i, pos in pairs(candidates) do
 local tile = g_map.getTile(pos)
  if tile then
   if tile:getText():len() == 0 then 
    table.remove(candidates, i)
   end
  local item1 = findItem(2981)
  local item2 = findItem(2983)
  local item3 = findItem(2984)
  if tile:getText() == "FLOWER MW" then rune = 3180 end
   if tile:canShoot() and not isInPz() and tile:isWalkable() and tile:getTopUseThing():getId() ~= 2130 and tile:getTopUseThing():getId() ~= 2129 and tile:getTopUseThing():getId() ~= 2981 and tile:getTopUseThing():getId() ~= 2982 and tile:getTopUseThing():getId() ~= 2983 then
    if math.abs(player:getPosition().x-tile:getPosition().x) < 10 and math.abs(player:getPosition().y-tile:getPosition().y) < 10 then
     if item1 then
      return g_game.move(item1,  pos, 1)
     elseif item2 then
      return g_game.move(item2,  pos, 1)
     elseif item3 then
      return g_game.move(item3,  pos, 1)
     end
      return useWith(rune, tile:getTopUseThing())
    end
   end
  end
 end
end)

onRemoveThing(function(tile, thing)
if thing:getId() ~= 2129 or thing:getId() ~= 2130 or thing:getId() ~= 2981 or thing:getId() ~= 2982 or thing:getId() ~= 2983 then return end
 if tile:getText():find("FLOWER") then
  table.insert(candidates, tile:getPosition())
  local item1 = findItem(2981)
  local item2 = findItem(2983)
  local item3 = findItem(2984)
  if tile:getText() == "FLOWER MW" then rune = 3180 end
  if item1 then
   return g_game.move(item1,  pos, 1)
  elseif item2 then
   return g_game.move(item2,  pos, 1)
  elseif item3 then
   return g_game.move(item3,  pos, 1)
  end
   return useWith(rune, tile:getTopUseThing())
 end
end)

onAddThing(function(tile, thing)
if m.isOff() then return end
if thing:getId() ~= 2129 or thing:getId() ~= 2130 or thing:getId() ~= 2981 or thing:getId() ~= 2982 or thing:getId() ~= 2983 then return end
 if tile:getText():len() > 0 then
  table.remove(candidates, table.find(candidates,tile))
 end
end)

onKeyDown(function(keys)
local wsadWalking = modules.game_walking.wsadWalking
if not wsadWalking then return end
if m.isOff() then return end
if keys ~= storage.extras.holdMwHot then return end
hold = now
local tile = getTileUnderCursor()
if not tile then return end
if math.abs(player:getPosition().x-tile:getPosition().x) == 0 and math.abs(player:getPosition().y-tile:getPosition().y) == 0 then return end
if tile:getText():len() > 0 then
 tile:setText("")
else
if keys == storage.extras.holdMwHot and not isInPz() then
 tile:setText("FLOWER MW")
end
 table.insert(candidates, tile:getPosition())
end
end)

onKeyPress(function(keys)
local wsadWalking = modules.game_walking.wsadWalking
if not wsadWalking then return end
if m.isOff() then return end
if keys ~= storage.extras.holdMwHot then return end
 if (hold - now) < -1000 then
  candidates = {}
  for i, tile in ipairs(g_map.getTiles(posz())) do
   local text = tile:getText()
   if text:find("FLOWER") then
    tile:setText("")
   end
  end
 end
end)
UI.Separator()

---------------------------- MW NO PONTEIRO DO MOUSE

mwmouse = "hotkeynamw"
if not storage[mwmouse] then
 storage[mwmouse] = { key = 'F10'}
end
UI.Label("Hotkey MW no mouse: ")
UI.TextEdit(storage[mwmouse].key or "F10", function(widget, newText)
    storage[mwmouse].key = newText
end)
onKeyUp(function(keys)
 if (keys ~= storage[mwmouse].key) then return end
 local tile = getTileUnderCursor();
 if (not tile) then return; end
 local pos = tile:getPosition();
 useWith(3180, tile:getTopUseThing())
end)
UI.Separator()

----------------------------  MW NA FRENTE DO TARGET

mwfrente = "hotkeymwf"
if not storage[mwfrente] then
 storage[mwfrente] = { hkf = ''}
end
UI.Label("Hotkey MW Frente Target:")
UI.TextEdit(storage[mwfrente].hkf, function(widget, newText)
    storage[mwfrente].hkf = newText
end)

local mwallId = 3180 -- Mwall ID
local squaresThreshold = 2 -- quantidade de sqm a tacar MW frente do char
onKeyUp(function(keys)
if (keys ~= storage[mwfrente].hkf) then return end
local target = g_game.getAttackingCreature() or g_game.getFollowingCreature()
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

---------------------------- SUMMON

macro(500, "Vocation Summon", function()
  if not timeSummon or timeSummon <= now then
  if isInPz() then return end
  if modules.game_cooldown.isGroupCooldownIconActive(3) then return end
  local voc_data = { [11] = "eq", [1] = "eq", [12] = "sac", [2] = "sac", [13] = "ven", [3] = "ven", [14] = "dru", [4] = "dru", }
  local spell_end = voc_data[player:getVocation()]
    if spell_end and lvl() >= 200 then
      local spell = "utevo gran res " .. spell_end
      if canCast(spell) then
        cast(spell)
        timeSummon = now + 1805000
      end
    end
  end
end)

---------------------------- BP PRINCIPAL SEMPRE ABERTA

macro(1000, "Main BP Open",function()
    bpItem = getBack()
    bp = getContainer(0)
    if not bp and bpItem ~= nil then
        g_game.open(bpItem)
    end
end)

---------------------------- LIMPAR TEXTOS

macro(1000, "Limpar Textos", function()
    modules.game_textmessage.clearMessages()
    g_map.cleanTexts()
end)
UI.Separator()

---------------------------- CLICK REUSE

local reUseToggle = macro(1000, "Click ReUse", "", function() end)
local excluded = {268, 237, 238, 23373, 266, 236, 239, 7643, 23375, 7642, 23374, 5908, 5942, storage.extras.shovel, storage.extras.rope, storage.extras.machete} 

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
UI.Separator()

---------------------------- ESCONDER ALIADOS

local ui = setupUI([[
Panel
  height: 37

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    !text: tr('Hide Allies Members')

  BotSwitch
    id: hideguild
    anchors.top: title.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 17
    margin-top: 4
    text-align: center

    $on:
      text: Hide Guild Editor

    $!on:
      text: Show Guild Editor

]])

local hideguild = setupUI([[
Panel
  height: 50

  Label
    id: guildsName
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 8
    margin-left: 40
    height: 17
    text: Enter allies guild
    color: white

  BotTextEdit
    id: guildTextOne
    anchors.top: guildsName.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: 5
    font: verdana-11px-rounded

]])
hideguild:hide()

if not storage.hideguild then
 storage.hideguild = {
  enabled = false,
}
end

local config = storage.hideguild

ui.hideguild.onClick = function(widget)
if not CaveBot.Config then return end
if ui.hideguild:isOn() then
 hideguild:hide()
 ui.hideguild:setOn(false)
else
 hideguild:show()
 ui.hideguild:setOn(true)
end
end

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
    config.enabled = not config.enabled
    widget:setOn(config.enabled)
end

hideguild.guildTextOne:setText(config.guildasaliadas)
hideguild.guildTextOne.onTextChange = function(widget, newText)
 config.guildasaliadas = newText
end

local filterPanel = modules.game_battle.filterPanel
modules.game_battle.battleWindow:show()

modules.game_battle.doCreatureFitFilters = function(creature)
    if creature:isLocalPlayer() then
      return false
    end
    if creature:getHealthPercent() <= 0 then
      return false
    end

    local pos = creature:getPosition()
    if not pos then return false end

    local isBotServer = vBot.BotServerMembers[creature:getName()]
    local localPlayer = g_game.getLocalPlayer()
    if pos.z ~= localPlayer:getPosition().z or not creature:canBeSeen() then return false end

    local hidePlayers = filterPanel.buttons.hidePlayers:isChecked()
    local hideNPCs = filterPanel.buttons.hideNPCs:isChecked()
    local hideMonsters = filterPanel.buttons.hideMonsters:isChecked()
    local hideSkulls = filterPanel.buttons.hideSkulls:isChecked()
    local hideParty = filterPanel.buttons.hideParty:isChecked()
  
    if hidePlayers and creature:isPlayer() then
      return false
    elseif hideNPCs and creature:isNpc() then
      return false
    elseif hideMonsters and creature:isMonster() then
      return false
    elseif hideSkulls and creature:isPlayer() and creature:getSkull() == SkullNone then
      return false
    elseif hideParty and creature:getShield() > ShieldWhiteBlue then
      return false
    elseif config.enabled and ((isFriend(creature) or creature:getEmblem() == 1 or creature:getEmblem() == 4 or isBotServer)) then
      return false
    end

    if storage.extras.checkPlayer and config.enabled then
    local guildText = config.guildasaliadas:lower()
    local creatureText = creature:getText():lower()
     if guildText:len() > 0 then
      local dividirs = string.split(guildText, ",")
      for i=1,#dividirs do
       local dividir = dividirs[i]
       dividir = dividir:trim()
       dividir = dividir:lower()
       if dividir:len() > 10 then
        dividir = dividir:sub(1,10)
        dividir = dividir.."..."
        if creatureText:find(dividir) then
         return false
        end
       end
      end
     end
    end
    return true
end
ui.title:setTooltip("Ao adicionar uma nova guilda aliada, ligue e desligue \n o hide guild para esconder a guilda aliada adicionada.")
ui.hideguild:setTooltip("Edite a lista de aliados usando virgula.")

UI.Separator()

---------------------------- MANA TRAINING

UI.Label("Mana training")
if type(storage.manaTrain) ~= "table" then
  storage.manaTrain = {on=false, title="MP%", text="utevo lux", min=80, max=100}
end

local manatrainmacro = macro(1000, function()
  if TargetBot and TargetBot.isActive() then return end -- pausa o treino enquanto target estiver on
  local mana = math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
  if storage.manaTrain.max >= mana and mana >= storage.manaTrain.min then
    say(storage.manaTrain.text)
  end
end)
manatrainmacro.setOn(storage.manaTrain.on)

UI.DualScrollPanel(storage.manaTrain, function(widget, newParams) 
  storage.manaTrain = newParams
  manatrainmacro.setOn(storage.manaTrain.on)
end)
UI.Separator()

---------------------------- MUDER OUTFIT DO LIDER

targetColorName = "targetcolor"
if not storage[targetColorName] then storage[targetColorName] = { player = 'name'} end

UI.Label("Nome do Frontline")

targetColorTE = UI.TextEdit(storage[targetColorName].player or "name", function(widget, newText)
    storage[targetColorName].player = newText
end)

local leaderName = ''
local numberoutfit = 1407

macro(100, "Procurar", function()

    if not storage[targetColorName].player or storage[targetColorName].player == 'name' then return end
    leaderName = storage[targetColorName].player

    local specs = getSpectators()
    for _, spec in ipairs(specs) do
        if spec:isPlayer() and spec:getName() == leaderName  then
            local specOutfit = spec:getOutfit()
            if specOutfit.type == numberoutfit then
                return
            end
            specOutfit.type = numberoutfit
            spec:setOutfit(specOutfit)
        end
    end
end)

UI.Separator()

---------------------------- ADVANCED FOLLOW (PRECISA SER MELHORADO)

local followThis = tostring(storage.followLeader)

FloorChangers = {
    Ladders = {
        Up = {1948, 5542, 16693, 16692, 8065, 8263, 7771, 20573, 20475, 21297 },
        Down = {432, 412, 469, 1080}
    },

    Holes = { -- teleports
        Up = {},
        Down = {293, 35500, 294, 595, 1949, 4728, 385, 9853, 37000, 37001, 35499, 35497, 29979, 25047, 25048, 25049, 25050, 
                25051, 25052, 25053, 25054, 25055, 25056, 25057, 25058, 21046, 21048 }
    },

    RopeSpots = { -- buracos pra usar corda
        Up = {386, 12202, 21965, 21966},
        Down = {}
    },

    Stairs = {
        Up = {16690, 1958, 7548, 7544, 1952, 1950, 1947, 7542, 855, 856, 1978, 1977, 6911, 6915, 1954, 5259, 20492, 1956, 775,
              5257, 5258, 22566, 22747, 30757, 20225, 17395, 1964, 1966, 20255, 29113, 28357, 30912, 30906, 30908, 30914, 
              30916, 30904, 30918, 20750, 20750, 20491, 20474, 20496 },

        Down = {482, 414, 437, 7731, 413, 434, 859, 438, 6127, 566, 7476, 4826, 484, 433, 369, 20259, 19960, 411,
                8690, 4825, 6130, 601, 1067, 567, 7768, 1067, 411, 600 }
    },

    Sewers = {
        Up = {1082},
        Down = {435,21298}
    },

    Levers = {
        Up = {2772, 2773, 1759, 1764, 21051, 7131, 7132, 39756},
        Down = {2772, 2773, 1759, 1764, 21051, 7131, 7132, 39756}
    },
}

local openDoors = { 34847, 1764, 21051, 30823, 6264, 5282, 20453, 11705, 6256, 2772, 27260, 2773, 1632, 6252, 5007, 1629, 5107, 5281, 1968, 31116, 31120, 30742, 31115, 31118, 20474, 5736, 5733, 31202, 31228, 31199, 31200, 33262, 30824, 5125, 5126, 5116, 8257, 8258, 8255, 8256, 5120, 30777, 30776, 23873, 23877, 5736, 6264, 31262, 31130, 6249, 5122, 30049, 7727, 25803, 16277, 5098, 5104, 5102, 5106, 5109, 5111, 5113, 5118, 5120, 5102, 5100, 1638, 1640, 19250, 3500, 3497, 3498, 3499, 2177, 17709, 1642, 23875, 1644, 5131, 5115, 28546, 6254, 28546, 30364, 30365, 30367, 30368, 30363, 30366, 31139, 31138, 31136, 31137, 4981, 4977, 11714, 7771, 9558, 9559, 20475, 2909, 2907, 8618, 31366, 1646, 1648, 4997, 22506, 8259, 27503, 27505, 27507, 31476, 31477, 31477, 31475, 31474, 8363, 5097, 1644, 7712, 7715, 11237, 11246, 9874, 6260, 33634, 33633, 22632, 22639, 1631, 1628, 20446, 20443, 20444, 2334, 9357, 9355 }

onTalk(function(name, level, mode, text, channelId, pos)
if AdvancedFollow:isOn() then
  if mode == 1 and name == storage.followLeader then
    if text:lower():find("hi thais yes") then
      CaveBot.Travel("thais")
    end
    if text:lower():find("hi carlin yes") then
      CaveBot.Travel("carlin")
    end
    if text:lower():find("hi edron yes") then
      CaveBot.Travel("edron")
    end
    if text:lower():find("hi venore yes") then
      CaveBot.Travel("venore")
    end
    if text:lower():find("hi darashia yes") then
      CaveBot.Travel("darashia")
    end
    if text:lower():find("hi ankrahmun yes") then
      CaveBot.Travel("ankrahmun")
    end
  end
end
end)

local target = followThis
local lastKnownPosition
local lastKnownDirection

local function goLastKnown()
    if getDistanceBetween(pos(), {x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z}) > 1 then
        local newTile = g_map.getTile({x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z})
        if newTile then
            g_game.use(newTile:getTopUseThing())
            delay(math.random(100, 400))
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
            delay(math.random(100, 400))
        end
    end
end

local function handleStep(pos)
    goLastKnown()
    local lastZ = posz()
    if posz() == lastZ then
        autoWalk(pos)
        delay(math.random(100, 400))
    end
end

local function handleRope(pos)
    goLastKnown()
    local lastZ = posz()
    if posz() == lastZ then
        local newTile = g_map.getTile({x = pos.x, y = pos.y, z = pos.z})
        if newTile then
            useWith(storage.extras.rope, newTile:getTopUseThing())
            delay(math.random(100, 400))
        end
    end
end

local floorChangeSelector = {
    Ladders = {Up = handleUse, Down = handleStep},
    Holes = {Up = handleStep, Down = handleStep},
    RopeSpots = {Up = handleRope, Down = handleRope},
    Stairs = {Up = handleStep, Down = handleStep},
    Sewers = {Up = handleUse, Down = handleUse},
    Levers = {Up = handleUse, Down = handleUse},
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

local function lastTurnDir()
    local target = getCreatureByName(storage.followLeader)
    local pdir = player:getDirection()
	if target then
        local tdir = target:getDirection()
        toChangeDir[tdir] = tdir
    end
    local p = toChangeDir[tdir]
    if not p then
        return
    end
    if targetZ:getDirection() ~= player:getDirection() then
        turn(pdir)
    end
end

local function turnDir()
    local targetZ = getCreatureByName(storage.followLeader)
    local pdir = player:getDirection()
    for _, n in ipairs(getSpectators(true)) do
        if n:getName() == storage.followLeader then
            targetZ = n
        end
    end
    if not targetZ then return end
    local targetDir = targetZ:getDirection()
    if targetZ and targetZ:getPosition().z == posz() and targetZ:getDirection() ~= player:getDirection() then
        turn(targetDir)
    end
end

local function WallDetect()

    local targetZ = getCreatureByName(storage.followLeader)
    local position = player:getPosition()

	for _, n in ipairs(getSpectators(true)) do
        if n:getName() == storage.followLeader then
            targetZ = n
        end
    end
    if not targetZ then return end

    local targetZ = getCreatureByName(storage.followLeader)
    local position = player:getPosition()

	for _, n in ipairs(getSpectators(true)) do
        if n:getName() == storage.followLeader then
            targetZ = n
        end
    end
    if not targetZ then return end
    local targetDir = targetZ:getDirection()
    if targetZ and targetZ:getPosition().z ~= posz() and targetZ:getDirection() ~= player:getDirection() then
        lastKnownDirection = targetZ:getDirection()
    end
    local tile
    if lastKnownDirection == 0 then -- north
        turn(lastKnownDirection)
        position.y = position.y - 1
        tile = g_map.getTile(position)
    elseif lastKnownDirection == 1 then -- east
        turn(lastKnownDirection)
        position.x = position.x + 1
        tile = g_map.getTile(position)
    elseif lastKnownDirection == 2 then -- south
        turn(lastKnownDirection)
        position.y = position.y + 1
        tile = g_map.getTile(position)
    elseif lastKnownDirection == 3 then -- west
        turn(lastKnownDirection)
        position.x = position.x - 1
        tile = g_map.getTile(position)
    end
	
    if targetZ:getPosition().z == posz() then return true
    elseif targetZ:getPosition().z - posz() >= 1 then say('exani hur "down') -- jump "down"
            delay(math.random(100, 400))
    elseif targetZ:getPosition().z - posz() <= -1 then say('exani hur "up') -- jump "up"
            delay(math.random(100, 400))
    end
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
    local checkZ = {}
    local targetZ = nil
    for _, n in ipairs(getSpectators(true)) do
        if n:getName() == target then
            targetZ = n
        end
    end
    if not targetZ then table.insert(checkZ,"Down")
    elseif targetZ:getPosition().z == posz() then return true
    elseif targetZ:getPosition().z - posz() >= 1 then table.insert(checkZ,"Down")
    elseif targetZ:getPosition().z - posz() <= -1 then table.insert(checkZ,"Up")
    end
    for _, dir in ipairs(checkZ) do
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

followChange = macro(200, "Follow Change", function() end)

local toFollowPos = {}

AdvancedFollow = macro(20, "Advanced Follow", "", function(macro)
if followMacro.isOn() then followMacro.setOff() end
    local target = getCreatureByName(storage.followLeader)
    local pPos = player:getPosition()
    if target then
        local tpos = target:getPosition()
        toFollowPos[tpos.z] = tpos
    end
    if player:isWalking() then
        return
    end
    local p = toFollowPos[posz()]
    if not p then
        return
    end
    if autoWalk(p, 20, {ignoreNonPathable=true, precision=1}) then
        delay(tonumber(1))
    end

	turnDir()
	
    checkTargetPos()
    if targetMissing() and lastKnownPosition then
        handleFloorChange()
    end
    if targetMissing() and lastKnownPosition and possibleChangers == nil then
        WallDetect()
    end
    if not targetMissing() and getDistanceBetween(pos(), target:getPosition()) >= 3 then
     for _, NEWtile in pairs(g_map.getTiles(posz())) do
      if distanceFromPlayer(NEWtile:getPosition()) == 1 then
       if table.find(openDoors, NEWtile:getTopUseThing():getId()) then
        g_game.use(NEWtile:getTopUseThing())
        delay(math.random(500, 800))
       end
      end
     end
    end
end)


followled = addTextEdit("playerToFollow", storage.followLeader or "Leader name", function(widget, text)
    storage.followLeader = text
    target = tostring(text)
end)
onPlayerPositionChange(function(newPos, oldPos)
  if followChange:isOff() then return end
  if (g_game.isFollowing()) then
    tfollow = g_game.getFollowingCreature()

    if tfollow then
      if tfollow:getName() ~= storage.followLeader then
        followled:setText(tfollow:getName())
        storage.followLeader = tfollow:getName()
      end
    end
  end
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
    if creature:getName() == storage.followLeader and newPos then
        toFollowPos[newPos.z] = newPos
    end
end)

---------------------------- FOLLOW COM DISTANCIA (NÃO USAR JUNTO COM O ADVANCED FOLLOW)

followdist = "disttofollow"
if not storage[followdist] then
 storage[followdist] = { dist = "3" }
end
UI.Label("Distance from player:")
UI.TextEdit(storage[followdist].dist or "3", function(widget, newText)
    storage[followdist].dist = newText
end)

UI.Label("Walk Delay")

UI.TextEdit(storage.delayf or "100", function(widget, newText)
    storage.delayf = newText
end)

followMacro = macro(20, "Follow", function()
if AdvancedFollow.isOn() then AdvancedFollow.setOff() end
    local target = getCreatureByName(storage.followLeader)
    local pPos = player:getPosition()
    if target then
        local tpos = target:getPosition()
        toFollowPos[tpos.z] = tpos
    end
    if player:isWalking() then
        return
    end
    local p = toFollowPos[posz()]
    if not p then
        return
    end
    if autoWalk(p, 20, {ignoreNonPathable=true, precision=1, marginMin=tonumber(storage[followdist].dist), marginMax=tonumber(storage[followdist].dist)}) then
        delay(tonumber(storage.delayf))
    end
end)
UI.Separator()

---------------------------- UTAMO/EXANA

if voc() == 3 or voc() == 4 or voc() == 13 or voc() == 14 then

local panelName = "utamoexana"
local ui = setupUI([[
Panel
  height: 110
  margin-top: 1

  Label
    id: uthp
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center

  HorizontalScrollBar
    id: uthpScroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: uthp.bottom
    margin-right: 4
    margin-left: 4
    margin-top: 5
    minimum: 1
    maximum: 100
    step: 1

  Label
    id: exhp
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: uthpScroll.bottom
    margin-top: 6
    text-align: center

  HorizontalScrollBar
    id: exhpScroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: exhp.bottom
    margin-right: 4
    margin-left: 4
    margin-top: 5
    minimum: 1
    maximum: 100
    step: 1

  Label
    id: exmana
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: exhpScroll.bottom
    margin-top: 6
    text-align: center

  HorizontalScrollBar
    id: exmanaScroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: exmana.bottom
    margin-right: 4
    margin-left: 4
    margin-top: 5
    minimum: 0
    maximum: 100
    step: 1

]])
ui:setId(panelName)

if not storage[panelName] then
  storage[panelName] = {
    percenthputamo = 20,
    percenthpexana = 20,
    percentmp = 20,
  }
end

local utexconfig = storage[panelName]

local updateUtHPText = function()
  ui.uthp:setText("HP% to Utamo Vita: "  .. utexconfig.percenthputamo .. "%")
end
ui.uthp:setText("HP% to Utamo Vita: "  .. utexconfig.percenthputamo .. "%")
ui.uthpScroll.onValueChange = function(scroll, value)
  utexconfig.percenthputamo = value
  updateUtHPText()
end

local updateExHPText = function()
  ui.exhp:setText("HP% to Exana Vita: "  .. utexconfig.percenthpexana .. "%")
end
ui.exhp:setText("HP% to Exana Vita: "  .. utexconfig.percenthpexana .. "%")
ui.exhpScroll.onValueChange = function(scroll, value)
  utexconfig.percenthpexana = value
  updateExHPText()
end

local updateExMPText = function()
  ui.exmana:setText("MP% to Exana/Utamo: "  .. utexconfig.percentmp .. "%")
end
ui.exmana:setText("MP% to Exana/Utamo: "  .. utexconfig.percentmp .. "%")
ui.exmanaScroll.onValueChange = function(scroll, value)
  utexconfig.percentmp = value
  updateExMPText()
end

ui.uthpScroll:setValue(utexconfig.percenthputamo)
ui.exhpScroll:setValue(utexconfig.percenthpexana)
ui.exmanaScroll:setValue(utexconfig.percentmp)

local exanaCD = 4000

UtamoExanaMacro = macro(20, "", function()
if UtamoMacro then UtamoMacro:setOff() end
 if hppercent() <= utexconfig.percenthputamo and not hasManaShield() and manapercent() > utexconfig.percentmp then
  say("utamo vita")
 elseif hasManaShield() and (hppercent() >= utexconfig.percenthpexana or manapercent() < utexconfig.percentmp) then
  say("exana vita")
  delay(exanaCD)
 end
 return
end)
UtamoExanaIcon = addIcon("utamoexana", {item={id=8090}, movable=true, text="Utamo\nExana"}, UtamoExanaMacro )

addSeparator()

---------------------------- UTAMO VITA % DO ESCUDO

local panelName = "AutoUtamo"
local ui = setupUI([[
Panel
  height: 55
  margin-top: 1

  Label
    id: manaTitle
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center

  HorizontalScrollBar
    id: manaScroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: manaTitle.bottom
    margin-right: 4
    margin-left: 4
    margin-top: 7
    minimum: 5
    maximum: 50
    step: 2

  CheckBox
    id: checkSpell
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: manaScroll.bottom
    margin-left: 3
    margin-right: 102
    margin-top: 8

  Label
    id: spellText
    anchors.left: checkSpell.left
    anchors.top: manaScroll.bottom
    margin-left: 15
    margin-top: 8
    text: Only Spell
    color: #ffaa00
    font: verdana-11px-rounded

  CheckBox
    id: checkPotion
    anchors.right: parent.right
    anchors.left: spellText.left
    anchors.top: manaScroll.bottom
    margin-left: 60
    margin-right: 3
    margin-top: 8

  Label
    id: potionText
    anchors.right: parent.right
    anchors.left: checkPotion.left
    anchors.top: manaScroll.bottom
    margin-left: 17
    margin-top: 8
    text: Spell + Potion
    color: #ffaa00
    font: verdana-11px-rounded

]])
ui:setId(panelName)

if not storage[panelName] then
  storage[panelName] = {
    CheckPotion = false,
    CheckSpell = false,
    manaPer = 20,
    shieldpercent = 51,
  }
end

local utamoconfig = storage[panelName]

ui.checkPotion:setChecked(utamoconfig.CheckPotion)
ui.checkPotion.onClick = function(widget)
  utamoconfig.CheckPotion = not utamoconfig.CheckPotion
  widget:setChecked(utamoconfig.CheckPotion)
end

ui.checkSpell:setChecked(utamoconfig.CheckSpell)
ui.checkSpell.onClick = function(widget)
  utamoconfig.CheckSpell = not utamoconfig.CheckSpell
  widget:setChecked(utamoconfig.CheckSpell)
end

local updateManaText = function()
  ui.manaTitle:setText("Shield to cast/use pot: "  .. utamoconfig.manaPer .. "%")
end
ui.manaTitle:setText("Shield to cast/use pot: "  .. utamoconfig.manaPer .. "%")

ui.manaScroll.onValueChange = function(scroll, value)
  utamoconfig.manaPer = value
  updateManaText()
end

ui.manaScroll:setValue(utamoconfig.manaPer)

local MaxShield = (8*player:getLevel() + 7*player:getMagicLevel())

UtamoMacro = macro(100, "", function()
local PerMana = utamoconfig.manaPer
if UtamoExanaMacro then UtamoExanaMacro:setOff() end
if not hasManaShield() and not isInPz() and not modules.game_cooldown.isGroupCooldownIconActive(3) and not modules.game_cooldown.isCooldownIconActive(44) then cast('utamo vita') end
if (utamoconfig.CheckSpell and utamoconfig.CheckPotion) then
  warn("Check only one box!")
  delay(2000)
  return
end
if utamoconfig.CheckSpell and not isInPz() then
 if not timecast or timecast <= now then
  if utamoconfig.shieldpercent < PerMana and not modules.game_cooldown.isGroupCooldownIconActive(3) and not modules.game_cooldown.isCooldownIconActive(44) then
   cast("utamo vita")
   utamoconfig.shieldpercent = 51
   timecast = now + 750
  end
 end
return
end
if utamoconfig.CheckPotion and not isInPz() then
 if utamoconfig.shieldpercent < PerMana then
  local magicPotion = findItem(35563)
  if not modules.game_cooldown.isGroupCooldownIconActive(3) and not modules.game_cooldown.isCooldownIconActive(44) then
   cast("utamo vita")
   utamoconfig.shieldpercent = 51
   timecast = now + 750
  elseif magicPotion and (modules.game_cooldown.isGroupCooldownIconActive(3) or modules.game_cooldown.isCooldownIconActive(44)) then
   g_game.use(magicPotion)
   utamoconfig.shieldpercent = 51
   timecast = now + 1000
  end
 end
return
end
end)
UtamoIcon = addIcon("AutoUtamo", {item={id=3548,count=1}, movable=true, text="Auto\nUtamo"}, UtamoMacro)

onTextMessage(function(mode, text)
if not autoutamo or not utamoconfig.CheckSpell or not utamoconfig.CheckPotion then return true end
 if mode == 20 then
 local regex = "Your mana barrier is only ([0-9]+)[%] ([(][0-9]+)[)][ left.]"
  if text:lower():find("your mana barrier is only") then
   local data = regexMatch(text, regex)[1]
   if #data ~= 0 then
    utamoconfig.shieldpercent = tonumber(data[2]) 
   end
  end
 end
end)
end
addSeparator()

---------------------------- SSA E MIGHT RING

SSAMight = macro(170, "", function()
local amulet = 3081
local might = 3048
if getNeck() == nill or getNeck():getId() ~= amulet then
g_game.equipItemId(amulet)
delay(30)
end
if getFinger() == nill or getFinger():getId() ~= might then
g_game.equipItemId(might)
delay(30)
end
end)
addIcon("SSA", {item={id = 3081}, movable=true, hotkey="Home", text="SSA"}, SSAMight )