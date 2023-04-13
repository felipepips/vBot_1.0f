--[[
vBot Scripting Services / Serviços de script / Servicios de scripting:
Discord: F.Almeida#8019

(ENG) If you like it, consider making a donation:
(PT) Se você gostou, considere fazer uma doação:
(ESP) Si le gusta, considere hacer una donación:
https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

The original UI of this module was created by Lee#7225
https://trainorcreations.com/coding/otclient/27
--]]

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.

setDefaultTab("HP")


local buffUi = setupUI([[
Panel
  height: 20

  BotSwitch
    id: status
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    height: 18
    text: Auto Buff

  Button
    id: editSpellList
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 18
    text: Setup
  ]], parent)

g_ui.loadUIFromString([[
SpellName < Label
  background-color: alpha
  text-offset: 2 0
  focusable: true
  height: 16

  $focus:
    background-color: #00000055

  Button
    id: remove
    text: x
    anchors.right: parent.right
    margin-right: 15
    width: 15
    height: 15

spellListWindow < MainWindow
  text: Auto Buff by F.Almeida
  size: 220 355
  @onEscape: self:hide()

  Label
    id: lblPos
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.right: parent.right
    text-align: center
    margin-top: -5
    text: Icon Position:

  Label
    id: lblPosX
    anchors.left: prev.left
    anchors.top: prev.bottom
    text-align: center
    margin-top: 5
    width: 40
    height: 20
    !text: ('Pos X: ')

  SpinBox
    id: ipx
    anchors.left: prev.right
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    minimum: 0
    maximum: 2000
    width: 50
    step: 10
    editable: true
    focusable: true

  Label
    id: lblPosY
    anchors.left: prev.right
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    margin-left: 10
    text-align: center
    width: 40
    !text: ('Pos Y: ')

  SpinBox
    id: ipy
    anchors.right: parent.right
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    minimum: 0
    maximum: 2000
    width: 50
    step: 10
    editable: true
    focusable: true

  Label
    id: lblEx
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-top: 5
    height: 20
    text-align: center
    text: Default Exhausted:

  SpinBox
    id: ex
    anchors.right: parent.right
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    minimum: 0
    maximum: 5000
    width: 70
    step: 100
    editable: true
    focusable: true
    text-align: center

  Label
    id: lblSpells
    anchors.left: parent.left
    anchors.top: prev.bottom
    anchors.right: parent.right
    margin-top: 5
    text-align: center
    text: Spells List
    
  TextList
    id: lstSpells
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    margin-bottom: 5
    padding: 1
    height: 100
    vertical-scrollbar: AutoBuffVScroll
    
  VerticalScrollBar
    id: AutoBuffVScroll
    anchors.top: lstSpells.top
    anchors.bottom: lstSpells.bottom
    anchors.right: lstSpells.right
    step: 14
    pixels-scroll: true

  Label
    id: lblExample
    anchors.left: parent.left
    anchors.top: prev.bottom
    anchors.right: parent.right
    margin-top: 5
    text-align: center
    text: Example: Utito Tempo, 10000
    
  TextEdit
    id: spellEntry
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-top: 5
    width: 140

  Button
    id: addSpell
    text: +
    font: verdana-11px-rounded
    anchors.right: parent.right
    anchors.left: prev.right
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    margin-left: 3
  

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-top: 8

  CheckBox
    id: checkAtk
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 6
    text: Stop if attacking
    tooltip: Only cast buff if not attacking any creature.

  CheckBox
    id: checkPz
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 6
    text: Stop if in PZ
    tooltip: Only cast buff if not in Protection Zone.

  CheckBox
    id: createIcon
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 6
    text: Create Icon

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 6

  Button
    id: closeButton
    text: Close
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21

  Button
    id: info
    text: Credits
    font: cipsoftFont
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    size: 45 21
    color: yellow
    !tooltip: tr('Created by F.Almeida#8019\nClick to contribute.')
    @onClick: g_platform.openUrl("https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD")
]])

local panelName = "autoBuff"

if not storage[panelName] then
  storage[panelName] = {
    iconPosX = 200,
    iconPosY = 170,
    exhausted = 1001,
    spellList = {"set some spell first, 3000"},
    enabled = false,
    icon = false,
    atk = false,
    pz = true,
  }
end

local config = storage[panelName]

rootWidget = g_ui.getRootWidget()
if rootWidget then

  spellListWindow = UI.createWindow('spellListWindow', rootWidget)
  spellListWindow:hide()

  buffUi.editSpellList.onClick = function(widget)
    spellListWindow:show()
    spellListWindow:raise()
    spellListWindow:focus()
  end

  spellListWindow.closeButton.onClick = function(widget)
    spellListWindow:hide()
  end

  if config.spellList and #config.spellList > 0 then
    for _, pName in ipairs(config.spellList) do
      local label = g_ui.createWidget("SpellName", spellListWindow.lstSpells)
      label.remove.onClick = function(widget)
        table.removevalue(config.spellList, label:getText())
        label:destroy()
      end
      label:setText(pName)
      label.onDoubleClick = function(widget)
        table.removevalue(config.spellList, label:getText())
        spellListWindow.spellEntry:setText(label:getText())
        label:destroy()
      end
    end
  end
  spellListWindow.addSpell.onClick = function(widget)
    local spellEntry = spellListWindow.spellEntry:getText():lower()
    if spellEntry:len() > 0 and not table.contains(config.spellList, spellEntry, true) then
      if string.find(spellEntry,",") then
        if not tonumber(spellEntry:split(",")[2]) then
          warn('You must insert: spell name, cooldown (in ms: 1000 = 1s)')
        else
          table.insert(config.spellList, spellEntry)
          local label = g_ui.createWidget("SpellName", spellListWindow.lstSpells)
          label.remove.onClick = function(widget)
            table.removevalue(config.spellList, label:getText())
            label:destroy()
          end
          label:setText(spellEntry)
          spellListWindow.spellEntry:setText('')
          label.onDoubleClick = function(widget)
            table.removevalue(config.spellList, label:getText())
            spellListWindow.spellEntry:setText(label:getText())
            label:destroy()
          end
        end
      else
        warn('You must insert: spell name, cooldown (in ms: 1000 = 1s)')
      end
    end
  end

  buffUi.status:setOn(config.enabled)
  buffUi.status.onClick = function(widget)
    config.enabled = not config.enabled
    widget:setOn(config.enabled)
  end

  spellListWindow.checkAtk:setChecked(config.atk)
  spellListWindow.checkAtk.onClick = function(widget)
    config.atk = not config.atk
    widget:setChecked(config.atk)
  end

  spellListWindow.checkPz:setChecked(config.pz)
  spellListWindow.checkPz.onClick = function(widget)
    config.pz = not config.pz
    widget:setChecked(config.pz)
  end

  spellListWindow.createIcon:setChecked(config.icon)
  spellListWindow.createIcon.onClick = function(widget)
    config.icon = not config.icon
    widget:setChecked(config.icon)
  end

  spellListWindow.spellEntry.onKeyPress = function(self, keyCode, keyboardModifiers)
    if not (keyCode == 5) then
      return false
    end
    spellListWindow.addSpell.onClick()
    return true
  end

  spellListWindow.spellEntry.onTextChange = function(widget, text)
    if table.contains(config.spellList, text, true) then
      spellListWindow.addSpell:setColor("red")
    elseif text:len() > 0 then
      spellListWindow.addSpell:setColor("green")
    else
      spellListWindow.addSpell:setColor("white")
    end
  end

  -- icon positions
  spellListWindow.ipx:setValue(config.iconPosX)
  spellListWindow.ipx.onValueChange = function(widget, value)
    config.iconPosX = value
  end

  spellListWindow.ipy:setValue(config.iconPosY)
  spellListWindow.ipy.onValueChange = function(widget, value)
    config.iconPosY = value
  end

  -- default exhausted
  spellListWindow.ex:setValue(config.exhausted)
  spellListWindow.ex.onValueChange = function(widget, value)
    config.exhausted = value
  end

  -- add icon
  local icon = addIcon("BuffIcon", {text="Auto\nBuff",item=3064,switchable=true},function(w,on) 
    config.enabled = on
  end)
  icon.text:setFont('verdana-11px-rounded')
  icon:breakAnchors()
  if not config.icon then
    icon:hide()
  end
  
  -- main loops
  -- switches
  macro(100,function()
    icon.setOn(config.enabled)
    buffUi.status:setOn(config.enabled)
    icon:move(config.iconPosX,config.iconPosY)
    if config.icon then
      icon:show()
    else
      icon:hide()
    end
  end)
  -- auto buff
  macro(500,function()
    if not config.enabled then return end
    if g_game.isAttacking() and config.atk then return end
    if isInPz() and config.pz then return end

    for e, entry in pairs(config.spellList) do
      local spell = entry:split(",")[1]
      local cd = tonumber(entry:split(",")[2])
      -- fix for vbot bug
      local a,b,c = modules.gamelib.Spells.getSpellByWords(spell)
      local Spells = modules.gamelib.SpellInfo['Default']
      local s = Spells[c]
      if s then
        if type(s.mana) == 'string' then
          s.mana = 1
        end
      end
      -- end fix
      if canCast(spell) then
        cast(spell,cd)
        delay(config.exhausted)
        return
      end
    end

  end)
end

-- UI.Separator()