-- Use Rune on Follow
local runeId = 3160
local hotKey = nil -- nil or "keys" (example: "F12")
local exhausted = 250

local function runeTarget(target)
  local find = findItem(runeId)
  if find then
    useWith(find,target)
  else
    broadcastMessage("No More Runes")
  end
end

local rtMacro = macro(50, function()
  local tg = g_game.getFollowingCreature()
  if not tg then return end
  runeTarget(tg)
  delay(exhausted)
end)

local holdIcon = addIcon("holdIcon", {text = "Target", item = runeId, hotkey = hotKey}, rtMacro)
holdIcon.text:setFont("verdana-11px-rounded")