-- START CONFIG
local spell1 = "utito gran"
local spell2 = "utito tempo"
local time_between_spells = 2000 -- in milliseconds
local cooldown = 15000 --in milliseconds
-- END CONFIG


local wait = false
macro(100, "2 Spells", function() 
  if wait then return end

  say(spell1)

  schedule(time_between_spells, function()
    say(spell2)
  end)

  schedule(cooldown, function()
    wait = false
  end)

  wait = true
end)