setDefaultTab("HP")
UI.Separator()

UI.Label("Mana Training:")
if type(storage.manaTrain) ~= "table" then
  storage.manaTrain = {on=false, title="MP%", text="utevo lux", min=90, max=100}
end

local manatrainmacro = macro(1000, function()
  if TargetBot and TargetBot.isActive() then return end -- pause when attacking
  local mana = math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
  if storage.manaTrain.max >= mana and mana >= storage.manaTrain.min then
    say(storage.manaTrain.text)
  end
end)
manatrainmacro.setOn(storage.manaTrain.on)

UI.DualScrollPanel(storage.manaTrain, function(widget, newParams) 
  storage.manaTrain = newParams
  manatrainmacro.setOn(storage.manaTrain.on)
end)

-- UI.Separator()

-- UI.Label("Mana Training 2")
if type(storage.manaTrain2) ~= "table" then
  storage.manaTrain2 = {on=false, title="MP%", text="utani hur", min=80, max=100}
end

local manatrainmacro2 = macro(1000, function()
  if TargetBot and TargetBot.isActive() then return end -- pause when attacking
  local mana2 = math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
  if storage.manaTrain2.max >= mana2 and mana2 >= storage.manaTrain2.min then
    say(storage.manaTrain2.text)
  end
end)
manatrainmacro2.setOn(storage.manaTrain2.on)

UI.DualScrollPanel(storage.manaTrain2, function(widget, newParams) 
  storage.manaTrain2 = newParams
  manatrainmacro2.setOn(storage.manaTrain2.on)
end)

UI.Separator()