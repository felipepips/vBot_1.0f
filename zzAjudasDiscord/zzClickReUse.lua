local reUse = macro(10000, "Click ReUse", function() end)

onUseWith(function(pos, itemId, target, subType)
  if reUse.isOn() then
    schedule(50, function()
      item = findItem(itemId)
      if item then
        modules.game_interface.startUseWith(item)
      end
    end)
  end
end)