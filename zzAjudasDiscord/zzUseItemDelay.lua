-- use item with delay

-- START CONFIG
local macroName = "Use With Delay" -- button name
local items = {3725,3577,3606,6541,6544,6542,6545} -- always inside {}
local wait = 1 -- minutes
setDefaultTab("tools")
-- END CONFIG

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

macro(100,macroName,function()
  local time = 0
  for i=1,#items do
    local id = items[i]
    if findItem(id) then
      schedule(time,function()
        g_game.use(findItem(id))
      end)
      time = time + 250
    end
  end
  delay((wait*60*1000))
end)