macro(1000, "walk into ID",  function()
  for i, tile in ipairs(g_map.getTiles(posz())) do
    for u,item in ipairs(tile:getItems()) do
      if table.find(wtItem, item:getId()) then
        if CaveBot.isOn() then
          CaveBot.setOff()
          schedule(1000,function()
            CaveBot.setOn()
            end)
        end
        autoWalk(tile:getPosition(), 100, {ignoreNonPathable = true})
        break
      end
    end
  end
end)