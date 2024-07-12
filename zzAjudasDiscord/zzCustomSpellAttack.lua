local BossList = {"Crystal Lizard [B]","Shadow Lord [B]"} -- always inside {"mob1","mob2"} even if it's only one
local spell1 = "Utito Gran Mas Frigo" -- First Boss Spell
local spell2 = "Exevo Gran Max Frigo" -- Second Boss Spell
local spell3 = "Exori Max Pura" -- Third Boss Spell
local spell4 = "Exevo Max Frigo" -- No Boss Spell

macro(250,"Boss Spell & Anti-Stuck",function()
  -- First Check if it's attacking a Boss
  if g_game.isAttacking() then
    local c = g_game.getAttackingCreature()
    if c then
      local cName = string.split(c:getName()," [L.")[1]
      if table.find(BossList,cName) then
        say(spell1) -- try cast spell1
        say(spell2) -- if spell1 is in CD, use spell2
        say(spell3) -- if spell2 is in CD, use spell3
        return
      end
    end
  end
  
  -- Second, if is trapped or attacking any other mob
  if isTrapped() or g_game.isAttacking() then
    return say(spell4) -- cast last spell
  end
end)