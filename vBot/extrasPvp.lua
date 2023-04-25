setDefaultTab("Main")

-- securing storage namespace
local panelName = "extrasPvp"
storage[panelName] = storage[panelName] or {}
local settings = storage[panelName]

-- basic elements
extrasPvp = UI.createWindow('ExtrasPvpWindow', rootWidget)
extrasPvp:hide()
extrasPvp.closeButton.onClick = function(widget)
  extrasPvp:hide()
end

-- available options for dest param
local rightPanel = extrasPvp.content.right
local leftPanel = extrasPvp.content.left

-- objects made by Kondrah - taken from creature editor, minor changes to adapt
local addCheckBox = function(id, title, defaultValue, dest, tooltip)
  local widget = UI.createWidget('ExtrasPvpCheckBox', dest)
  widget.onClick = function()
    widget:setOn(not widget:isOn())
    settings[id] = widget:isOn()
  end
  widget:setText(title)
  widget:setTooltip(tooltip)
  if settings[id] == nil then
    widget:setOn(defaultValue)
  else
    widget:setOn(settings[id])
  end
  settings[id] = widget:isOn()
end

local addItem = function(id, title, defaultItem, dest, tooltip)
  local widget = UI.createWidget('ExtrasPvpItem', dest)
  widget.text:setText(title)
  widget.text:setTooltip(tooltip)
  widget.item:setTooltip(tooltip)
  widget.item:setItemId(settings[id] or defaultItem)
  widget.item.onItemChange = function(widget)
    settings[id] = widget:getItemId()
  end
  settings[id] = settings[id] or defaultItem
end

local addTextEdit = function(id, title, defaultValue, dest, tooltip)
  local widget = UI.createWidget('ExtrasPvpTextEdit', dest)
  widget.text:setText(title)
  widget.textEdit:setText(settings[id] or defaultValue or "")
  widget.text:setTooltip(tooltip)
  widget.textEdit.onTextChange = function(widget,text)
    settings[id] = text
  end
  settings[id] = settings[id] or defaultValue or ""
end

local addScrollBar = function(id, title, min, max, defaultValue, dest, tooltip)
  local widget = UI.createWidget('ExtrasPvpScrollBar', dest)
  widget.text:setTooltip(tooltip)
  widget.scroll:setRange(min, max)
  widget.scroll.onValueChange = function(scroll, value)
    widget.text:setText(title .. ": " .. value)
    if value == 0 then
      value = 1
    end
    settings[id] = value
  end
  widget.scroll:setTooltip(tooltip)
  if max-min > 1000 then
    widget.scroll:setStep(100)
  elseif max-min > 100 then
    widget.scroll:setStep(10)
  end
  widget.scroll:setValue(settings[id] or defaultValue)
  widget.scroll.onValueChange(widget.scroll, widget.scroll:getValue())
end

UI.Button("Extras (PVP Scripts)", function()
  extrasPvp:show()
  extrasPvp:raise()
  extrasPvp:focus()
end):setColor('orange')
UI.Separator()

addItem("mwRune", "MW Rune", 3180, leftPanel, "Magic Wall Rune.")
addItem("mwObj", "Magic Wall", 2128, leftPanel, "Magic Wall Object.")
addScrollBar("mwTime", "MW Time (Seconds)", 1, 60, 20, leftPanel, "Default Magic Wall Time.")
addItem("wgRune", "WG Rune", 3156, leftPanel, "Wild Growth Rune.")
addItem("wgObj", "Wild Growth", 2130, leftPanel, "Wild Growth Object.")
addScrollBar("wgTime", "WG Time (Seconds)", 1, 60, 45, leftPanel, "Default Magic Wall Time.")

addCheckBox("timers", "MW & WG Timers", true, rightPanel, "Show times for Magic Walls and Wild Growths.")
if true then
  local activeTimers = {}
  local mwTime = settings.mwTime * 1000
  local wgTime = settings.wgTime * 1000

  onAddThing(function(tile, thing)
    if not settings.timers then return end
    if not thing:isItem() then return end
    local timer = 0
    if thing:getId() == settings.mwObj then
      timer = mwTime
    elseif thing:getId() == settings.wgObj then
      timer = wgTime
    else 
      return
    end

    local pos = tile:getPosition().x .. "," .. tile:getPosition().y .. "," .. tile:getPosition().z
    if not activeTimers[pos] or activeTimers[pos] < now then    
      activeTimers[pos] = now + timer
    end
    tile:setTimer(activeTimers[pos] - now)
  end)

  onRemoveThing(function(tile, thing)
    if not settings.timers then return end
    if not thing:isItem() then return end
    if (thing:getId() == settings.mwObj or thing:getId() == settings.wgObj) and tile:getGround() then
      local pos = tile:getPosition().x .. "," .. tile:getPosition().y .. "," .. tile:getPosition().z
      activeTimers[pos] = nil
      tile:setTimer(0)
    end  
  end)
end

addCheckBox("holdMwall", "Hold Wall", false, rightPanel, "Mark tiles with below hotkeys to automatically use Magic Wall or Wild Growth")
addTextEdit("holdMwHot", "Magic Wall Hotkey:", "Ctrl+F9", rightPanel)
addTextEdit("holdWgHot", "Wild Growth Hotkey:", "Ctrl+F10", rightPanel)
if true then
  local mwHot = settings.holdMwHot
  local wgHot = settings.holdWgHot
  local mwRune = settings.mwRune
  local wgRune = settings.wgRune
  local mw = settings.mwObj
  local wg = settings.wgObj
  local texts = {"HOLD MW","HOLD WG"}

  local candidates = {}
  local m = macro(50, function()
    if not settings.holdMwall then return end
      if #candidates == 0 then return end

      for i, pos in pairs(candidates) do
        local tile = g_map.getTile(pos)
        if tile then
          local text = tile:getText()
          if table.find(texts,text) then
            local rune = text == "HOLD MW" and mwRune or wgRune
            local obj = text == "HOLD MW" and mw or wg
            if tile:canShoot() and not isInPz() and tile:isWalkable() and tile:getTopUseThing():getId() ~= obj then
              return useWith(rune, tile:getTopUseThing())
            end
          else
            table.remove(candidates, i)
          end
        else
          table.remove(candidates, i)
        end
      end
  end)

  onRemoveThing(function(tile, thing)
    if not settings.holdMwall then return end
    if thing:getId() ~= mw and thing:getId() ~= wg then return end
    if tile and tile:getText():find("HOLD") then
      local rune = tile:getText() == "HOLD MW" and mwRune or wgRune
      return useWith(rune, tile:getTopUseThing())
    end
  end)

  onKeyDown(function(keys)
    local wsadWalking = modules.game_walking.wsadWalking
    if not wsadWalking then return end
    if not settings.holdMwall then return end
    if m.isOff() then return end
    if keys ~= mwHot and keys ~= wgHot then return end

    local tile = getTileUnderCursor()
    if not tile then return end

    if tile:getText():len() > 0 then
      tile:setText("")
    else
      local obj = keys == mwHot and mw or wg
      local rune = keys == mwHot and mwRune or wgRune
      if keys == mwHot then
        tile:setText("HOLD MW")
      else
        tile:setText("HOLD WG")
      end
      if tile:canShoot() and not isInPz() and tile:isWalkable() and tile:getTopUseThing():getId() ~= obj then
        return useWith(rune, tile:getTopUseThing())
      end
      table.insert(candidates, tile:getPosition())
    end
  end)
end

-- PUSH MAX
addItem("vsRune", "VS Anti-Push", 3188, leftPanel, "Field rune to throw on target if trashed, to allow pushing.")
addScrollBar("vsDelay", "Push Delay", 1, 3000, 1100, leftPanel, "Default delay for pushing.")
addCheckBox("pushMax", "Push Max", false, rightPanel, "Mark players and destionations with below hotkey to push target.")
addTextEdit("pushHot", "Push Max Hotkey:", "PageUp", rightPanel)
if true then
  local config = {
    enabled = settings.pushMax,
    pushDelay = settings.vsDelay,
    pushMaxRuneId = settings.vsRune,
    mwallBlockId = settings.mwObj,
    pushMaxKey = settings.pushHot
  }

    -- variables for config
  local fieldTable = {2118, 105, 2122}
  local cleanTile = nil

  -- scripts 

  local targetTile
  local pushTarget

  local resetData = function()
    for i, tile in pairs(g_map.getTiles(posz())) do
      if tile:getText() == "TARGET" or tile:getText() == "DEST" or tile:getText() == "CLEAR" then
        tile:setText('')
      end
    end
    pushTarget = nil
    targetTile = nil
    cleanTile = nil
  end

  local getCreatureById = function(id)
    for i, spec in ipairs(getSpectators()) do
      if spec:getId() == id then
        return spec
      end
    end
    return false
  end

  local isNotOk = function(t,tile)
    local tileItems = {}

    for i, item in pairs(tile:getItems()) do
      table.insert(tileItems, item:getId())
    end
    for i, field in ipairs(t) do
      if table.find(tileItems, field) then
        return true
      end
    end
    return false
  end

  local isOk = function(a,b)
    return getDistanceBetween(a,b) == 1
  end

  -- to mark
  local hold = 0
  onKeyDown(function(keys)
    if not config.enabled then return end
    if keys ~= config.pushMaxKey then return end
    hold = now
    local tile = getTileUnderCursor()
    if not tile then return end
    if pushTarget and targetTile then
      resetData()
      return
    end
    local creature = tile:getCreatures()[1]
    if not pushTarget and creature then
      pushTarget = creature
      if pushTarget then
        tile:setText('TARGET')
        pushTarget:setMarked('#00FF00')
      end
    elseif not targetTile and pushTarget then
      if pushTarget and getDistanceBetween(tile:getPosition(),pushTarget:getPosition()) ~= 1 then
        resetData()
        return
      else
        tile:setText('DEST')
        targetTile = tile
      end
    end
  end)

  -- mark tile to throw anything from it
  onKeyPress(function(keys)
    if not config.enabled then return end
    if keys ~= config.pushMaxKey then return end
    local tile = getTileUnderCursor()
    if not tile then return end

    if (hold - now) < -2500 then
      if cleanTile and tile ~= cleanTile then
        resetData()
      elseif not cleanTile then
        cleanTile = tile
        tile:setText("CLEAR")
      end
    end
    hold = 0
  end)

  onCreaturePositionChange(function(creature, newPos, oldPos)
    if not config.enabled then return end
    if creature == player then
      resetData()
    end
    if not pushTarget or not targetTile then return end
    if creature == pushTarget and newPos == targetTile then
      resetData()
    end
  end)

  macro(50, function()
    if not config.enabled then return end

    local pushDelay = tonumber(config.pushDelay)
    local rune = tonumber(config.pushMaxRuneId)
    local customMwall = config.mwallBlockId

    if cleanTile then
      local tilePos = cleanTile:getPosition()
      local pPos = player:getPosition()
      if not isOk(tilePos, pPos) then
        resetData()
        return
      end

      if not cleanTile:hasCreature() then return end
      local tiles = getNearTiles(tilePos)
      local destTile
      local forbidden = {}
      -- unfortunately double loop
      for i, tile in pairs(tiles) do
        local minimapColor = g_map.getMinimapColor(tile:getPosition())
        local stairs = (minimapColor >= 210 and minimapColor <= 213)
        if stairs then
          table.insert(forbidden, tile:getPosition())
        end
      end
      for i, tile in pairs(tiles) do
        local minimapColor = g_map.getMinimapColor(tile:getPosition())
        local stairs = (minimapColor >= 210 and minimapColor <= 213)
        if tile:isWalkable() and not isNotOk(fieldTable, tile) and not tile:hasCreature() and not stairs then
          local tooClose = false
          if #forbidden ~= 0 then
            for i=1,#forbidden do
              local pos = forbidden[i]
              if isOk(pos, tile:getPosition()) then
                tooClose = true
                break
              end
            end
          end
          if not tooClose then
            destTile = tile
            break
          end
        end
      end

      if not destTile then return end
      local parcel = cleanTile:getCreatures()[1]
      if parcel then
        test()
        g_game.move(parcel,destTile:getPosition())
        delay(2000)
      end
    else
      if not pushTarget or not targetTile then return end
      local tilePos = targetTile:getPosition()
      local targetPos = pushTarget:getPosition()
      if not isOk(tilePos,targetPos) then return end
      
      local tileOfTarget = g_map.getTile(targetPos)
      
      if not targetTile:isWalkable() then
        local topThing = targetTile:getTopUseThing():getId()
        if topThing == 2129 or topThing == 2130 or topThing == customMwall then
          if targetTile:getTimer() < pushDelay+500 then
            vBot.isUsing = true
            schedule(pushDelay+700, function()
              vBot.isUsing = false
            end)
          end
          if targetTile:getTimer() > pushDelay then
            return
          end
        else
          return resetData()
        end
      end

      if not tileOfTarget:getTopUseThing():isNotMoveable() and targetTile:getTimer() < pushDelay+500 then
        return useWith(rune, pushTarget)
      end
      if isNotOk(fieldTable, targetTile) then
        if targetTile:canShoot() then
          return useWith(3148, targetTile:getTopUseThing())
        else
          return
        end
      end
        g_game.move(pushTarget,tilePos)
        delay(2000)
    end
  end)
end

-- HOLD TARGET
addCheckBox("holdTarget", "Hold Target", true, rightPanel, "Hold Target (press ESC to cancel attack).")
addTextEdit("holdIconPos", "Icon Position:", "200,200", rightPanel, "Restart Bot to change position.\nLeave it blank if you don't want an icon.\nPut any other text to let you move where you want.")
if true then
  local targetID = nil

  -- 'Escape' when attacking will reset hold target
  onKeyPress(function(keys)
    if keys == "Escape" and targetID then
      targetID = nil
    end
  end)

  local holdTarg = macro(100, function()
    if not settings.holdTarget then return end
    -- if attacking then save it as target, but check pos z in case of marking by mistake on other floor
    if target() and target():getPosition().z == posz() and not target():isNpc() then
      targetID = target():getId()
    elseif not target() then
      -- there is no saved data, do nothing
      if not targetID then return end
      -- look for target
      for i, spec in ipairs(getSpectators()) do
        local sameFloor = spec:getPosition().z == posz()
        local oldTarget = spec:getId() == targetID
        if sameFloor and oldTarget then
          attack(spec)
        end
      end
    end
  end)

  -- icon
  local iconHoldTarget = addIcon("Hold",
  {outfit={mount=0,feet=94,legs=94,body=94,type=129,auxType=0,addons=3,head=94}, movable=true, text="Hold\nTarget"}, holdTarg)
  iconHoldTarget.text:setFont('verdana-11px-rounded')
  iconHoldTarget:setSize({height = 70, width = 45})
  local split = settings.holdIconPos:split(",")
  if split[2] then
  local x, y = tonumber(split[1]), tonumber(split[2])
  if x and y then
    iconHoldTarget:breakAnchors()
    iconHoldTarget:move(x,y)
  end
  elseif settings.holdIconPos == "" then
    iconHoldTarget:hide()
    if settings.holdTarget then holdTarg:setOn() end
  end
end