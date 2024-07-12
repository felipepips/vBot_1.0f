local exhausted = 1000 -- ms

setDefaultTab("Main")
local lab = UI.Label("[[ SELECT PROFILE ]]")
lab:setColor("orange")
lab:setFont("verdana-11px-rounded")

local ui = setupUI([[
Panel
  height: 25

  ComboBox
    id: profile
    anchors.top: prev.bottom
    width: 176
    options: [Knight, Paladin, Sorcerer, Druid]
]])

storage.multiMacroProfile = storage.multiMacroProfile or "Knight"

ui.profile:setText(storage.multiMacroProfile)
ui.profile.onOptionChange = function(widget)
  storage.multiMacroProfile = widget:getCurrentOption().text
end

local hp = {
  normal = 266, -- TODAS 150-200HP
  strong = 236, -- EK/RP 50+ 300HP
  great = 239, -- EK 80+ 500HP
  ultimate = 7643, -- EK 130+ 750HP
  supreme = 23375, -- EK 200+ 900HP
}
local mp = {
  normal = 268, -- TODAS 70-130MP
  strong = 237, -- TODAS 50+ 150MP
  great = 238, -- RP/MAGES 80+ 200MP
  ultimate = 23373, -- MAGES 130+ 500MP
}
local spirit = {
  great = 7642, -- RP 80+ 300HP 150MP
  ultimate = 23374, -- RP 130+ 500HP 200MP
}

local config = {
  ["Knight"] = {
    ["ManaTrain"] = {
      {min = 8, max = 10, mpPercent = 60, spell = "Utevo Lux"},
      {min = 11, max = 9999, mpPercent = 70, spell = "Exura Ico"},
    },
    ["LifeHeal"] = {
      -- {level min, level max, config = {lista em ordem de prioridade, menor hp pro maior}
      {min = 10, max = 79, configs = {
        {hpPercent = 70, usar = {hp.small}},
      }},
      {min = 80, max = 199, configs = {
        {hpPercent = 70, usar = {hp.strong,hp.small}},
      }},
      {min = 200, max = 19999, configs = {
        {hpPercent = 70, usar = {hp.supreme,hp.strong,hp.small}},
      }},
    },
    ["ManaHeal"] = {
      {min = 10, max = 100, configs = {
        {mpPercent = 50, usar = {mp.supreme}},
        {mpPercent = 70, usar = {mp.strong,mp.small}},
      }},
    },
  }
}

-- MACRO MANA TRAIN
macro(exhausted,"Mana Train",function()
  local voc = storage.multiMacroProfile
  local profile = config[voc]["ManaTrain"]
  if not profile then return end
  local level = lvl()
  local mana = manapercent()
  for e, entry in pairs(profile) do
    if entry.min <= level and level <= entry.max then
      if mana >= entry.mpPercent then
        say(entry.spell)
        return delay(exhausted)
      end
    end
  end
end)

-- MACRO LIFE HEAL
macro(250,"Life Heal",function()
  local voc = storage.multiMacroProfile
  local profile = config[voc]["LifeHeal"]
  if not profile then return end
  local level = lvl()
  local health = hppercent()
  for e, entry in pairs(profile) do
    if entry.min <= level and level <= entry.max then
      for level, cfg in pairs(entry.configs) do
        if health <= cfg.hpPercent then
          for i, item in pairs(cfg.usar) do
            if type(item) == 'string' and canCast(item) then
              cast(item,exhausted)
              return delay(exhausted)
            elseif type(item) == 'number' and findItem(item) then
              useWith(item,player)
              return delay(exhausted)
            end
          end
        end
      end
    end
  end
end)

-- MACRO MANA HEAL
macro(250,"Mana Heal",function()
  local voc = storage.multiMacroProfile
  local profile = config[voc]["ManaHeal"]
  if not profile then return end
  local level = lvl()
  local mana = manapercent()
  for e, entry in pairs(profile) do
    if entry.min <= level and level <= entry.max then
      for level, cfg in pairs(entry.configs) do
        if mana <= cfg.mpPercent then
          for i, item in pairs(cfg.usar) do
            if type(item) == 'string' and canCast(item) then
              cast(item,exhausted)
              return delay(exhausted)
            elseif type(item) == 'number' and findItem(item) then
              useWith(item,player)
              return delay(exhausted)
            end
          end
        end
      end
    end
  end
end)