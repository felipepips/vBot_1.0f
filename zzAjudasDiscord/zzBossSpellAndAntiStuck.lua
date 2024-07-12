local BossList = 
{"Crystalbeast [B]","Shadow Lord [B]","Doomlord [B]","Void Lord [B]","Sharptooth [B]","Doomcrawler [B]","Desert King [B]","Doombringer [B]","Doom Dragon [B]","Toxic Mage [B]","Jaul [B]","Crystal Lizard [B]","Mindreader [B]","Elf Overlord [B]","Cult Leader [B]","Mutated Pumpkin [B]","Gigantic Eyeball [B]","Ancient Mage [B]","Corrupted Demon [B]","Lethal Golem [B]","Dreamhaunter [B]","Omega Spider [B]","Noxious Mage [B]","Grand Tauren [B]","Shadow Rider [B]","Seacrestus [B]","Verminor [B]","Shadow Rider [B]","Great Succubus [B]"} -- always inside {"mob1","mob2"} even if it's only one
local spell1 = "Utito Tempo San" -- First Boss Spell
local spell2 = "Exevo Gran Mas San" -- Second Boss Spell
local spell3 = "Exori Max Star" -- Third Boss Spell
local spell4 = "Exevo Max Row" -- No Boss Spell

macro(250,"Bosskiller 3000",function()
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
  
  -- Not attacking boss
  if isTrapped() or g_game.isAttacking() then
    say(spell2) -- try cast spell2 first
    if getMonsters(8,false) == 1 or (g_game.isAttacking() and g_game.getAttackingCreature():isPlayer()) then
      say(spell3) -- if only 1 mob on screen or attacking a player, and spell2 is in CD, use spell3
    else
      say(spell4) -- if more than 1 mob on screen, and spell2 is in CD, use spell4
    end
  end
end)