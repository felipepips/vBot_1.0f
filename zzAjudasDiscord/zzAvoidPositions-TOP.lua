local block_item = 100
local mark_color = "red"
local positions = {
  {32327,32214,7,0} -- always put an ",0" at the end
}

macro(100,"Avoid Positions",function(m)
  for e, entry in pairs(positions) do
    local tile = g_map.getTile({x = entry[1], y = entry[2], z = entry[3]})
    if tile then
      local things = tile:getThings()
      for i, item in pairs(things) do
        if item:getId() == block_item then
          -- revert
          schedule(100,function()
            if m:isOn() then return end
            if entry[4] > 0 then
              item:setId(entry[4])
              item:setMarked("")
            end
          end)
          return
        end
      end
      local top = tile:getTopThing()
      if top then
        entry[4] = top:getId()
        top:setId(block_item)
        top:setMarked(mark_color)
      end
    end
  end
end)