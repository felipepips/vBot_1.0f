-- low stamina potion
-- tags: below refill hours

-- START CONFIG
local potionId = 1234 -- POTION ID, ONLY NUMBERS
local min = 40 -- MIN HOURS TO USE POTION
-- END CONFIG

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

macro(5000,"Stamina Refill",function() 
  local stamina = (stamina() / 60)
  if stamina <= min then
    if g_game.getClientVersion() < 860 then
      local potion = findItem(potionId)
      if potion then useWith(potion,player) end
    else
      useWith(potionId,player)     
    end
  end
end)