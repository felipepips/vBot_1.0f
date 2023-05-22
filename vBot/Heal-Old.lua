setDefaultTab("HP")
-- UI.Separator()

UI.Label("Healing Spels:")

if type(storage.healing1) ~= "table" then
  storage.healing1 = {on=false, title="HP%", text="exura", min=51, max=90}
end
if type(storage.healing2) ~= "table" then
  storage.healing2 = {on=false, title="HP%", text="exura vita", min=0, max=50}
end

-- create 2 healing widgets
for _, healingInfo in ipairs({storage.healing1, storage.healing2}) do
  local healingmacro = macro(20, function()
    local hp = player:getHealthPercent()
    if healingInfo.max >= hp and hp >= healingInfo.min then
      if TargetBot then 
        TargetBot.saySpell(healingInfo.text) -- sync spell with targetbot if available
      else
        say(healingInfo.text)
      end
    end
  end)
  healingmacro.setOn(healingInfo.on)

  UI.DualScrollPanel(healingInfo, function(widget, newParams) 
    healingInfo = newParams
    healingmacro.setOn(healingInfo.on)
  end)
end

UI.Separator()

UI.Label("Healing Items:")

if type(storage.hpitem1) ~= "table" then
  storage.hpitem1 = {on=false, title="HP%", item=3152, min=51, max=90}
end
if type(storage.hpitem2) ~= "table" then
  storage.hpitem2 = {on=false, title="HP%", item=3160, min=0, max=50}
end
if type(storage.manaitem1) ~= "table" then
  storage.manaitem1 = {on=false, title="MP%", item=2874, min=0, max=50}
end
-- if type(storage.manaitem2) ~= "table" then
  -- storage.manaitem2 = {on=false, title="MP%", item=3157, min=0, max=50}
-- end

for i, healingInfo in ipairs({storage.hpitem1, storage.hpitem2, storage.manaitem1
--, storage.manaitem2
}) do
  local healingmacro = macro(20, function()
    local hp = i <= 2 and player:getHealthPercent() or math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
    if healingInfo.max >= hp and hp >= healingInfo.min then
      if TargetBot then 
        TargetBot.useItem(healingInfo.item, healingInfo.subType, player) -- sync spell with targetbot if available
      else
        local thing = g_things.getThingType(healingInfo.item)
        local subType = g_game.getClientVersion() >= 860 and 0 or 1
        if thing and thing:isFluidContainer() then
          subType = healingInfo.subType
        end
        g_game.useInventoryItemWith(healingInfo.item, player, subType)
      end
    end
  end)
  healingmacro.setOn(healingInfo.on)

  UI.DualScrollItemPanel(healingInfo, function(widget, newParams) 
    healingInfo = newParams
    healingmacro.setOn(healingInfo.on and healingInfo.item > 100)
  end)
end

if g_game.getClientVersion() < 780 then
  UI.Label("In old tibia potions & runes work only when you have backpack with them opened")
end