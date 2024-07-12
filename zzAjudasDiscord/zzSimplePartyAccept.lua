-- Auto Accept Party of anyone that invites you
-- Auto say with delay

-- tags: auto pt party team invite talk

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

macro(1000,"Auto Accept Party",function() 
  if player:getShield() > 2 then return end -- already in a party
  for s, spec in pairs(getSpectators(false)) do
    if spec:getShield() == 1 then
      g_game.partyJoin(spec:getId())
      delay(1000)
    end
  end
end)


local text = "pt"
local wait = 2 -- minutes

macro(100,"Auto Say",function() 
  if player:getShield() > 2 then return end -- already in a party
  say(text)
  delay(wait*60*1000)
end)