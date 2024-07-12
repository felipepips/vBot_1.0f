local getOutfits = function()
  for _, spec in ipairs(getSpectators()) do
    if not spec:isMonster() then
      local specOutfit = spec:getOutfit()
      print(spec:getName().." Outfit:")
      print("head: ".. specOutfit.head)
      print("body: ".. specOutfit.body)
      print("legs: ".. specOutfit.legs)
      print("feet: ".. specOutfit.feet)
      print("addons: ".. specOutfit.addons)
      print("type: ".. specOutfit.type )
    end
  end
end

singlehotkey("Ctrl+J","Get Outfits",function() getOutfits() end)