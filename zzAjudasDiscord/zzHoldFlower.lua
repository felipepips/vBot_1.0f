-- Auto drop item on specific position
-- Tags: hold flower sqm

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD


-- START CONFIG:
-- YOU CAN USE ABSOLUTE POSITIONS, RELATIVE POSITIONS OR BOTH.
local itemIds = {140}
local absolutePositions = {}
local relativePositions = {"south", "north", "west", "east", "southeast", "northwest", "southwest", "northeast"}
-- END CONFIG

--[[
Example Config:
local itemIds = {2983} or {2984,2985}
local absolutePositions = {x=33233,y=32396,z=7} or {{x=33233,y=32396,z=7},{x=33237,y=32396,z=7}} or {}
local relativePositions = {"south"} or {"south","southwest"} or {}

posible relative positions: center, south, north, west, east, southeast, northeast, southwest & northeast.
--]]


-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.


local relative = {
  center = {0,0},
  south = {0,1},
  north = {0,-1},
  west = {-1,0},
  east = {1,0},
  southeast = {1,1},
  northeast = {1,-1},
  southwest = {-1,1},
  northwest = {-1,-1},
}

local dropitem = macro(500,"Hold Flower",function()
  if time and time > now then return end

  local positions = {}

  if type(absolutePositions) == "table" and absolutePositions[1] then
    for _, p in pairs(absolutePositions) do
      table.insert(positions,p)
    end
  end

  if type(relativePositions) == "table" and relativePositions[1] then
    for o, off in pairs(relativePositions) do
      if relative[off:lower()] then
        local p = pos()
        local off = relative[off:lower()]
        local pos = {x = p.x + off[1] , y = p.y + off[2] , z = p.z}
        table.insert(positions,pos)
      end
    end
  end

  if not positions[1] then return true end
  for p, pos in pairs(positions) do
    local tile = g_map.getTile({x=pos.x,y=pos.y,z=pos.z})
    if tile and tile:canShoot() and tile:isWalkable() then
      local topUse = tile:getTopUseThing()
      if topUse then
        local topId = topUse:getId()
        if not table.find(itemIds,topId) then
          for i, item in pairs(itemIds) do
            local dropItem = findItem(item)
            if dropItem then
              g_game.move(dropItem,pos,1)
              local time = now + 500
              break
            end
          end
        end
      end
    end
  end
end)