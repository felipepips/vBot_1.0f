-- START CONFIG
local hp_item_id = 23375
local hp_item_min_hp = 65
local mana_item_id = 237
local mana_item_min_mp = 50
local spell = "exura"
local spellMinHP = 90
local exhausted = 1000
-- END CONFIG

local time = 0
macro(100, "3 Heal",function()
  if time > now then return end
  if hppercent() <= hp_item_min_hp then
    time = now + exhausted
    return g_game.useInventoryItemWith(hp_item_id, player)
  end
  if manapercent() <= mana_item_min_mp then
    time = now + exhausted
    return g_game.useInventoryItemWith(mana_item_id, player)
  end
  if hppercent() <= spellMinHP then
    time = now + exhausted
    return say(spell)
  end
end)