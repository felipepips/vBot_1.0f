-- SAFE MANA HEAL
local mana_rune = 1234 -- MANA RUNE ID
local mana_max = 90 -- percent
local monsters = 0
local max_dist = 8
-- END CONFIG

local sfMacro = macro(250,function()
  local mana = manapercent()
  if mana < mana_max then
    local mobs = 0
    for s, spec in pairs(getSpectators()) do
      if spec:isMonster() then
        mobs = mobs + 1
        if mobs > monsters then
          break
        end
      end
    end
    if mobs <= monsters then
      useWith(mana_rune,player)
    end
  end
end)
addIcon("smIcon",{item=mana_rune,text="Safe\nMana"},sfMacro)


-- PAUSE CAVEBOT
local config = {min = 50, max = 90} -- min mana to pause, max mana to restart
-- END CONFIG

local paused
local pcMacro = macro(250,function()
  local mana = manapercent()
  if mana <= config.min then
    if CaveBot.isOn() then
      paused = true
      CaveBot.setOff()
    end
  elseif mana >= config.max then
    if paused then
      CaveBot.setOn()
      paused = false
    end
  end
end)
addIcon("pcIcon",{text="Safe\nCave"},pcMacro)