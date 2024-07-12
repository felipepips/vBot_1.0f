macro(1500, "Search for Item", function()
  local itemids = CaveBot.GetLootItems()
  for _, tile in ipairs(g_map.getTiles(posz())) do
    if getDistanceBetween(pos(), tile:getPosition()) <= 7 and freecap() > 400 then
      local top = tile:getTopUseThing()
      if table.find(itemids,top:getId()) then
        return moveToSlot(top,slotBack)
      end
    end
  end
end)