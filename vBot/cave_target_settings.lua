setDefaultTab("Cave")

-- securing storage namespace
local panelName = "extras"
storage[panelName] = storage[panelName] or {}
local settings = storage[panelName]

-- basic elements
CaveBotConfigsWindow = UI.createWindow('CaveBotConfigsWindow', rootWidget)
CaveBotConfigsWindow:hide()
CaveBotConfigsWindow.closeButton.onClick = function(widget)
  CaveBotConfigsWindow:hide()
end

-- available options for dest param
local rightPanel = CaveBotConfigsWindow.content.right
local leftPanel = CaveBotConfigsWindow.content.left

-- objects made by Kondrah - taken from creature editor, minor changes to adapt
local addCheckBox = function(id, title, defaultValue, dest, tooltip)
  local widget = UI.createWidget('ExtrasCheckBox', dest)
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
  local widget = UI.createWidget('CaveBotConfigsItem', dest)
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
  local widget = UI.createWidget('CaveBotConfigsTextEdit', dest)
  widget.text:setText(title)
  widget.textEdit:setText(settings[id] or defaultValue or "")
  widget.text:setTooltip(tooltip)
  widget.textEdit.onTextChange = function(widget,text)
    settings[id] = text
  end
  settings[id] = settings[id] or defaultValue or ""
end

local addScrollBar = function(id, title, min, max, defaultValue, dest, tooltip)
  local widget = UI.createWidget('CaveBotConfigsScrollBar', dest)
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

local btCave = UI.Button('CaveBot & Target Settings', function()
  CaveBotConfigsWindow:show()
  CaveBotConfigsWindow:raise()
  CaveBotConfigsWindow:focus()
end)
btCave:setColor('orange')
btCave:setImageColor('#2de0d7')
btCave:setFont("verdana-11px-rounded")
UI.Separator()

--- to maintain order, add options right after another:
--- add object
--- add variables for function (optional)
--- add callback (optional)
--- optionals should be addionaly sandboxed (if true then end)

addCheckBox("pathfinding", "CaveBot Pathfinding", true, rightPanel, "Cavebot will automatically search for first reachable waypoint after missing 10 goto's.")
addScrollBar("talkDelay", "Global NPC Talk Delay", 0, 2000, 1000, leftPanel, "Breaks between each talk action in cavebot (time in miliseconds).")
addScrollBar("looting", "Max Loot Distance", 0, 50, 40, leftPanel, "Every loot corpse futher than set distance (in sqm) will be ignored and forgotten.")
addScrollBar("lootDelay", "Loot Delay", 0, 2000, 200, leftPanel, "Wait time for loot container to open. Lower value means faster looting. \n WARNING if you are having looting issues(e.g. container is locked in closing/opnening), increase this value.")
addScrollBar("huntRoutes", "Hunting Rounds Limit", 0, 300, 50, leftPanel, "Round limit for supply check, if character already made more rounds than set, on next supply check will return to city.")
addScrollBar("killUnder", "Kill monsters below", 0, 100, 1, leftPanel, "Force TargetBot to kill added creatures when they are below set percentage of health - will ignore all other TargetBot settings.")
addScrollBar("gotoMaxDistance", "Max GoTo Distance", 0, 127, 30, leftPanel, "Maximum distance to next goto waypoint for the bot to try to reach.")
addCheckBox("lootLast", "Start loot from last corpse", true, rightPanel, "Looting sequence will be reverted and bot will start looting newest bodies.")
addCheckBox("joinBot", "Join TargetBot and CaveBot", false, rightPanel, "Cave and Target tabs will be joined into one.")
addCheckBox("reachable", "Target only pathable mobs", false, rightPanel, "Ignore monsters that can't be reached.")

addCheckBox("stake", "Skin Monsters", false, rightPanel, "Automatically skin & stake corpses when cavebot is enabled")
if true then
    -- START CONFIG
  local exhausted = 350
  local maxDistance = 6
  local config = {
    [5908] = { -- Obsidian Knife
      4286, 4272, 4173, 4011, 4025, 4047, 4052, 4057, 4062, 4112, 4212, 4321, 4324, 4327, 10352, 10356, 10360, 10364,
    },
    [5942] = { -- blessed wooden stake
      4097, 4137, 8738, 18958,
    },
    [3483] = { -- fishing
      9582
    }
  }
  -- END CONFIG

  local function lookAround()
    local maxLook = (TargetBot and TargetBot.isActive()) and 1 or maxDistance
    for x = -maxLook,maxLook do
      for y = -maxLook,maxLook do
        if x ~= 0 or y ~= 0 then
          local p = pos()
          p.x, p.y =  p.x + x, p.y + y
          local tile = g_map.getTile(p)
          if tile then
            local top = tile:getTopUseThing()
            if top and top:isContainer() then
              for stake, items in pairs(config) do
                local findStake = findItem(stake)
                local path = findPath(pos(),p,maxDistance)
                if findStake and path then
                  if table.find(items,top:getId()) then
                    local wait = #path * exhausted
                    CaveBot.delay(wait + exhausted)
                    return tile, findStake, wait
                  end
                end
              end
            end
          end
        end
      end
    end
    return false
  end

  macro(exhausted,function()
    if not settings.stake then return end
    if not CaveBot or not CaveBot.isOn() then return end
    local tile, stake, wait = lookAround()
    if tile then
      local top = tile:getTopUseThing()
      if top and top:isContainer() then
        useWith(stake, top)
        delay(wait)
        return
      end
    end
  end)
end

addCheckBox("suppliesControl", "TargetBot off if low supply", false, rightPanel, "Turn off TargetBot if either one of supply amount is below 50% of minimum.")
if true then
  macro(500, function()
    if not settings.suppliesControl then return end
    if TargetBot.isOff() then return end
    if CaveBot.isOff() then return end
    if type(hasSupplies()) == 'table' then
        TargetBot.setOff()
    end
  end)
end

addTextEdit("ignoreCreatures", "Ignore Creatures:", "deer,rabbit", leftPanel, "Creatures names to ignore.\nSeparated by commas.\ne.g.:'deer, rabbit'")

addCheckBox("showTargetPriority", "Show Target Priority", false, rightPanel)

addCheckBox("caveIcon", "Pause CaveBot Icon", true, rightPanel)
addCheckBox("targetIcon", "Pause TargetBot Icon", true, rightPanel)
if true then
    cIcon = addIcon("cI",{text="Cave\nBot",switchable=false,moveable=true}, function()
      if CaveBot.isOff() then 
        CaveBot.setOn()
      else 
        CaveBot.setOff()
      end
    end)
    cIcon:setSize({height=30,width=50})
    cIcon.text:setFont('verdana-11px-rounded')
    cIcon:breakAnchors()
    cIcon:move(200,75)
    cIcon:hide()

    tIcon = addIcon("cI",{text="Target\nBot",switchable=false,moveable=true}, function()
      if TargetBot.isOff() then 
        TargetBot.setOn()
      else 
        TargetBot.setOff()
      end
    end)
    tIcon:setSize({height=30,width=50})
    tIcon.text:setFont('verdana-11px-rounded')
    tIcon:breakAnchors()
    tIcon:move(200,105)
    tIcon:hide()

  macro(50,function()
    local c = settings.caveIcon
    local t = settings.targetIcon
    if c then
      cIcon:show()
      if CaveBot.isOn() then
        cIcon.text:setColoredText({"CaveBot\n","white","ON","green"})
      else
        cIcon.text:setColoredText({"CaveBot\n","white","OFF","red"})
      end
    else
      cIcon:hide()
    end
    if t then
      tIcon:show()
      if TargetBot.isOn() then
        tIcon.text:setColoredText({"Target\n","white","ON","green"})
      else
        tIcon.text:setColoredText({"Target\n","white","OFF","red"})
      end
    else
      tIcon:hide()
    end
  end)
end