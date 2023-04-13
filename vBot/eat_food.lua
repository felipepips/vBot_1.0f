setDefaultTab("HP")
-- UI.Separator()
if type(storage.foodItems) ~= "table" then
  storage.foodItems = {3607, 3592, 3600, 3601, 3725, 3582, 3577, 3578, 3583, 3723, 3731, 3732, 3595, 3593}
end

macro(500, "Eat Food", function()
  if player:getRegenerationTime() > 400 or not storage.foodItems[1] then return end
  -- search for food in containers
  for _, container in pairs(g_game.getContainers()) do
    for __, item in ipairs(container:getItems()) do
      for i, foodItem in ipairs(storage.foodItems) do
        if item:getId() == foodItem.id then
          return g_game.use(item)
        end
      end
    end
  end
end)

local foodContainer = UI.Container(function(widget, items)
  storage.foodItems = items
end, true)
foodContainer:setHeight(35)
foodContainer:setItems(storage.foodItems)

macro(500, "Conjure Food", function()
  if player:getRegenerationTime() <= 400 then
      cast("exevo pan", 5000)
  end
end)

UI.Separator()