-- storage
local panelName = "customFriendHealer"
storage[panelName] = storage[panelName] or {enabled = false, entries = {}}
local config = storage[panelName]

-- MISC
local spellList = {
  ["Targeted Spell"] = {
    "Blessing of Restoration",
    "Rejuvenating Charm",
    "Mana Tide",
    "Enchantment of Replenishment",
    "Critical Surge",
  },
  ["Party Spell"] = {
    "Group Salvation",
    "Divine Energies",
    "Unity Blessing",
  }
}

local convertHPMP = {
  ["Mana Percent"] = "MP%",
  ["Health Percent"] = "HP%",
  ["HP%"] = "Health Percent",
  ["MP%"] = "Mana Percent",
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
    !text: tr('Custom Friend Healer')

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
]])

local cfWindow = UI.createWindow('cfWindow')
local panel = cfWindow.healer.spells
cfWindow:hide()
cfWindow:setId(panelName)

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
  config.enabled = not config.enabled
  widget:setOn(config.enabled)
end

ui.edit.onClick = function()
  cfWindow:show()
  cfWindow:raise()
  cfWindow:focus()
end

cfWindow.closeButton.onClick = function(widget)
  cfWindow:hide()
end

-- SPELLS
panel.spellType.onOptionChange = function(widget)
  local combo = panel.spellName
  combo:clearOptions()
  local options = spellList[widget:getText()]
  for e, entry in pairs(options) do
    combo:addOption(entry)
  end
end
for e, entry in pairs(spellList) do
  panel.spellType:addOption(e)
end

-- end of UI

-- Refresh Entries
cfRefreshEntries = function()
  -- clear all
  for c, child in pairs(panel.entryList:getChildren()) do
    child:destroy()
  end
  for e, entry in ipairs(config.entries) do
    local label = UI.createWidget("cfSpellEntry", panel.entryList)
    -- store info in widget ^^
    label.name = entry.name
    label.HPorMP = entry.HPorMP
    label.percent = entry.percent
    label.spell = entry.spell
    label.group = entry.group
    -- enabled
    label.enabled:setChecked(entry.enabled)
    label.enabled.onClick = function(widget)
      entry.enabled = not entry.enabled
      label.enabled:setChecked(entry.enabled)
    end
    -- double click
    label.onDoubleClick = function(widget)
      panel.friendName:setText(label.name)
      panel.HPorMP:setText(convertHPMP[label.HPorMP])
      panel.percent:setText(label.percent)
      panel.spellType:setText(label.group)
      panel.spellName:setText(label.spell)
    end
    -- remove
    label.remove.onClick = function(widget)
      table.removevalue(config.entries, entry)
      reindexTable(config.entries)
      label:destroy()
      cfRefreshEntries()
    end
    -- move up
    if e == 1 then
      label.moveUp:setEnabled(false)
    end
    label.moveUp.onClick = function(widget)
      config.entries[e],config.entries[e-1] = config.entries[e-1],config.entries[e]
      panel.entryList:moveChildToIndex(label,e-1)
      panel.entryList:ensureChildVisible(label)
      cfRefreshEntries()
    end
    -- move down
    if e == #config.entries then
      label.moveDown:setEnabled(false)
    end
    label.moveDown.onClick = function(widget)
      config.entries[e],config.entries[e+1] = config.entries[e+1],config.entries[e]
      panel.entryList:moveChildToIndex(label,e+1)
      panel.entryList:ensureChildVisible(label)
      cfRefreshEntries()
    end
    text = "%s  |  %s < %d  |  %s"
    text = text:format(entry.name,entry.HPorMP,entry.percent,entry.spell)
    label:setText(text)
  end
end
cfRefreshEntries()

-- Add Spell
panel.addSpell.onClick = function(widget)
  local friendName = panel.friendName:getText():trim()
  local HPorMP = convertHPMP[panel.HPorMP:getText():trim()]
  local percent = tonumber(panel.percent:getText():trim())
  local group = panel.spellType:getText():trim()
  local spell = panel.spellName:getText():trim()

  if friendName:len() > 0 and percent and spell:len() > 0 then
    table.insert(config.entries,{
      enabled = true, name = friendName, HPorMP = HPorMP, percent = percent, spell = spell, group = group
    })
    cfRefreshEntries()
  end
end

-- store spells CD here
--[[
local spellsCD = {}
for group, g in pairs(spellList) do
  for spell, s in pairs(g) do
    local data = getSpellData(spell)
    if data then
      spellsCD[spell:lower()] = data.exhaustion
    else
      print("No Cooldown configured in Spells for spell: "..spell)
    end
  end
end
]]

-- Main Loop
macro(150,function()
  if not config.enabled then return end
  local foundPlayers = {}
  for e, entry in ipairs(config.entries) do
    if entry.enabled then
      local spell = entry.spell:lower()
      -- local CD = spellsCD[spell] or 1000
      -- if canCast(spell,CD) then
      if not getSpellCoolDown(spell) then
        local friend = getCreatureByName(entry.name)
        if friend then
          foundPlayers[friend] = foundPlayers[friend] or {
            hp = friend:getHealthPercent(),
            mp = friend:getManaPercent(),
          }
          local set = foundPlayers[friend]
          if (entry.HPorMP == "MP%" and set.mp <= entry.percent) or (entry.HPorMP == "HP%" and set.hp <= entry.percent) then
            if entry.group == "Party Spell" then
              say(entry.spell)
            else
              say(entry.spell..' "'..entry.name)
            end
            return delay(500)
          end
        end
      end
    end
  end
end)