-- storage
local panelName = "customPartyBuffv2"
storage[panelName] = storage[panelName] or {enabled = false}
local config = storage[panelName]

-- MISC
local spells = { -- higher lvl first
  ["Haste Party"] = {[1] = {level = 150, spell="Rushing Momentum"}},
  ["Buff Party"] = {[1] = {level = 1400, spell = "chorus of chaos"},[2] = {level = 600, spell = "melodic might"}},
  ["Protect Party"] = {[1] = {level = 1400, spell = "defense discord"},[2] = {level = 600, spell = "harmonic shield"}},
}

-- UI
setDefaultTab("Main")
local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Custom Party Buff')

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
]])

local cpWindow = UI.createWindow('cpWindow')
local panel = cpWindow.spells
cpWindow:hide()
cpWindow:setId(panelName)
cpWindow:setHeight((table.size(spells) * 20) + 110)

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
  config.enabled = not config.enabled
  widget:setOn(config.enabled)
end

ui.edit.onClick = function()
  cpWindow:show()
  cpWindow:raise()
  cpWindow:focus()
end

cpWindow.closeButton.onClick = function(widget)
  cpWindow:hide()
end

for spell, entry in pairs(spells) do
  local check = UI.createWidget("cpCheckBox", panel)
  check:setText(spell)
  check:setChecked(config[spell])
  check.onClick = function()
    config[spell] = not config[spell]
    check:setChecked(config[spell])
  end
end

-- main loop
macro(1000,function()
  if not config.enabled then return end
  local lv = lvl()
  for group, g in pairs(spells) do
    if config[group] then
      for s, spell in ipairs(g) do
        if lv >= spell.level and not getSpellCoolDown(spell.spell) then
          return say(spell.spell)
        end
      end
    end
  end
end)