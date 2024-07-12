-- Container Next Page
-- tags: gold golden pouch loot bag bp backpack pages

-- START CONFIG
-- to check all containers, set it to {} // or set specific id's: {1234} or {1234,1244,1245}
local containers_ids = {}
local macroName = "Next-Page"
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

macro(500, macroName, function()
  local containers = g_game.getContainers()
  for c, cont in ipairs(containers) do
    local cId = cont:getContainerItem():getId()
    if #containers_ids == 0 or table.find(containers_ids,cId) then
      if cont:hasPages() then 
        local nextPageButton = container.window:recursiveGetChildById('nextPageButton')
        if nextPageButton then nextPageButton.onClick() end
      end
    end
  end
end)