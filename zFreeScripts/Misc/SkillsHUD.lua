--[[
  Original made by Lee
  https://trainorcreations.com/coding/otclient/103

  Edited by F.Almeida
]]
setDefaultTab("Tools")
local checkSkills = macro(2000, 'Skills HUD', function()
  checkAll()
end)

skillsHud = "skillsHud"
if not storage[skillsHud] then
  storage[skillsHud] = { txt = '2,5,13,14'}
  checkSkills:setOn()
end

skillsText = UI.TextEdit(storage[skillsHud].txt, function(widget, newText)
    storage[skillsHud].txt = newText
end)

local panelName = "tcSkills"
local tcSkillPanel = setupUI([[
OutlineLabel < Label
  height: 12
  background-color: #00000044
  opacity: 0.89
  text-auto-resize: true
  font: verdana-11px-rounded
  anchors.left: parent.left
  $first:
    anchors.top: parent.top
  $!first:
    anchors.top: prev.bottom

Panel
  id: skillPanel
  height: 50
  width: 50
  anchors.left: parent.left
  anchors.bottom: parent.bottom
  margin-bottom: 5
  margin-left: 5
]], modules.game_interface.getMapPanel())

local skills = {
  { name = "Fist", data = {}, id = 0, enabled = false },
  { name = "Club", data = {}, id = 1, enabled = false },
  { name = "Sword", data = {}, id = 2, enabled = false },
  { name = "Axe", data = {}, id = 3, enabled = false },
  { name = "Distance", data = {}, id = 4, enabled = false },
  { name = "Shielding", data = {}, id = 5, enabled = false },
  { name = "Fishing", data = {}, id = 6, enabled = false },
  { name = "Crit Chance", data = {}, id = 7, enabled = false },
  { name = "Crit Damage", data = {}, id = 8, enabled = false },
  { name = "Life Leech Chance", data = {}, id = 9, enabled = false },
  { name = "Life Leech Amount", data = {}, id = 10, enabled = false },
  { name = "Mana Leech Chance", data = {}, id = 11, enabled = false },
  { name = "Mana Leech Amount", data = {}, id = 12, enabled = false },
  { name = "Level",  data = {}, id = 13, enabled = false, color = '#aba71e', highlight = 'orange' },
  { name = "Magic Level", data = {}, id = 14, enabled = false , color = '#4fc3f7', highlight = 'green'},
  { name = "Stamina", data = {}, id = 15, enabled = false },
}

local tip = "Available skills:"
for e, entry in pairs(skills) do
  entry.enabled = false
  tip = tip.."\n"..entry.name.." Id: "..entry.id
  for i, id in pairs(storage[skillsHud].txt:split(",")) do
    if tonumber(id:trim()) == entry.id then
      entry.enabled = true
    end
  end
end
skillsText:setTooltip("Need restart to update HUD.\n"..tip)

local firstSkill, lastSkill = 1, 13
local levelSkill = 14
local magicSkill = 15
local stamSkill = 16

function calcStamina()
  if checkSkills.isOff() then return end
  local stam = stamina()
  local hours = math.floor(stam / 60)
  local minutes = stam % 60
  if minutes < 10 then
    minutes = '0' .. minutes
  end
  local percent = math.floor(100 * stam / (42 * 60))
  return hours.. ':'.. minutes, ' ('..percent..'%)'
end

function checkStamina()
  if checkSkills.isOff() then return end
  local skill = skills[stamSkill]
  if skill and skill.enabled then
    local label = tcSkillPanel[stamSkill] or UI.createWidget("OutlineLabel", tcSkillPanel)
    label:setId(stamSkill)
    local sta, per = calcStamina()
    label:setColoredText({
      '~ '..skill.name..': ', (skill.color or 'white'),
      sta,(skill.highlight or 'green'),
      per, (skill.color or 'white'),
    })
  end
end

function checkMagicLevel()
  if checkSkills.isOff() then return end
  local skill = skills[magicSkill]
  if skill.enabled then
    local label = tcSkillPanel[magicSkill] or UI.createWidget("OutlineLabel", tcSkillPanel)
    label:setId(magicSkill)

    label:setColoredText({
      '~ '..skill.name..': ', (skill.color or 'white'),
      player:getMagicLevel(),(skill.highlight or 'green'),
      ' ('..player:getMagicLevelPercent().. '%)', (skill.color or 'white'),
    })
  end
end

function checkSkill(num)
  if checkSkills.isOff() then return end
  local skill = skills[num]
  if skill and skill.enabled and skill.id then
    local label = tcSkillPanel[skill.id] or UI.createWidget("OutlineLabel", tcSkillPanel)
      label:setId(skill.id)

    local t = {
      '~ '..skill.name..': ', (skill.color or 'white'),
      player:getSkillLevel(skill.id), (skill.highlight or 'green'),
      ' ('..player:getSkillLevelPercent(skill.id).. '%)', (skill.color or 'white'),
    }
    label:setColoredText(t)
  end
end


function checkLevel()
  if checkSkills.isOff() then return end
  local skill = skills[levelSkill]
  if skill.enabled then
    local label = tcSkillPanel[levelSkill] or UI.createWidget("OutlineLabel", tcSkillPanel)
    label:setId(levelSkill)

    label:setColoredText({
      '~ '..skill.name..': ', (skill.color or 'white'),
      level(), (skill.highlight or 'green'),
      ' ('.. player:getLevelPercent().. '%)', (skill.color or 'white'),
    })
  end
end

function checkAll()
  checkLevel()
  checkMagicLevel()
  for i = firstSkill, lastSkill do
    checkSkill(i, true)
  end
  checkStamina()
  tcSkillPanel:setHeight((tcSkillPanel:getChildCount()*13))
end

checkAll()
UI.Separator()