-- Use Rune on Follow
local runeId = 3160
local hotKey = nil -- nil or "keys" (example: "F12")

local function useOnTarget(target)
  local find = findItem(runeId)
  if find then
    useWith(find,target)
  else
    broadcastMessage("No More Runes")
  end
end

local useIcon = addIcon("iconRuneTarget"..runeId, {text = "Target", item = runeId, switchable = false, hotkey = hotKey}, function()
  local tg = g_game.getFollowingCreature()
  if not tg then
    return broadcastMessage("No Follow")
  end
  useOnTarget(tg)
end)
useIcon.text:setFont("verdana-11px-rounded")