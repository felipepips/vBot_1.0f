local spell1 = "Utito Gran Mas Frigo" -- First Spell
local spell2 = "Exevo Gran Max Frigo" -- Second Spell
local spell3 = "Exori Max Pura" -- Third Spell
local spell4 = "Exevo Max Frigo" -- No Boss Spell
local range_to_count_monsters = 7

macro(250,"Speller",function()
  local focus = target()
  if not focus then return end -- if not targeting, do nothing

  local mobsOnScreen = getMonsters(range_to_count_monsters)
  local focusDist = getDistanceBetween(pos(),focus:getPosition())

  -- PRIORITY ORDER 1 > 2 > 3 > 4

  -- SPELL 1: TARGET = BOSS ||OR|| TARGET = PLAYER
  if focus:isPlayer() or string.find(focus:getName(),"%[B%]") then
    say(spell1)
  end

  -- SPELL 2: TARGET DISTANCE <= 3 TILES
  if focusDist <= 3 then
    say(spell2)
  end

  -- SPELL 3: TARGET = BOSS ||OR|| TARGET = PLAYER ||OR|| ONLY 1 MOB ON SCREEN // AND // TARGET DIST <= 8
  if (focus:isPlayer() or string.find(focus:getName(),"%[B%]") or mobsOnScreen == 1) and focusDist <= 8 then
    say(spell3)
  end

  -- SPELL 4: 2+ MOBS ON SCREEN // AND // TARGET DISTANCE <= 5
  if mobsOnScreen >= 2 and focusDist <= 5 then
    say(spell4)
  end
end)