local tg

local tm = macro(10000000,"Cancel Atk Reflect",function() end)

-- save outfits
onAttackingCreatureChange(function(new, old)
  if tm:isOff() then return end
  tg = (new and new:isPlayer()) and new:getName() or nil
end)

onTalk(function(n,l,m,t)
  if tm:isOff() then return end
  if t:lower():find("reflect") and tg == n then
    g_game.cancelAttackAndFollow()
  end
end)

