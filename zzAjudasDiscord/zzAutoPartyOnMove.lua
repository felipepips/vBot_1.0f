local panelName = "panelName"
if not storage[panelName] then storage[panelName] = { leaderName = 'Cipfried' , fellas = 'Joyce, Miguel, Jesus'} end

local config = storage[panelName]

UI.Separator()
UI.Label("Auto-Party")

uiLeader = UI.TextEdit(config.leaderName or "Cipfried", function(widget, newText)
  config.leaderName = newText
end)
uiLeader:setTooltip("Leader Name")

uiFellas = UI.TextEdit(config.fellas or "Joyce, Miguel, Jesus", function(widget, newText)
  config.fellas = newText
end)
uiFellas:setTooltip("Guests names separated by commas")

autopt = macro(60*5*1000,"Auto-Party", function()
end)

onCreaturePositionChange(function(creature)
  if not autopt:isOn() then return end
  if creature:isPlayer() then
    if config.leaderName:lower() == creature:getName():lower() then
      g_game.partyJoin(creature:getId())
    elseif string.find(config.fellas:lower(),creature:getName():lower()) then
      g_game.partyInvite(creature:getId())
    end
  end
end)