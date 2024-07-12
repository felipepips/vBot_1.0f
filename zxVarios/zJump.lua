-- só pra eu poder testar..
local texts = {
  mode = 43,
  toFind = 'exani hur',
  down = 'exani hur "down',
  up = 'exani hur "up',
  tileText = "Jump Spot"
}

-- local texts = {
--   mode = 44,
--   toFind = 'jump',
--   down = 'jump down',
--   up = 'jump up',
--   tileText = "Jump Spot"
-- }

-- storage
storage.jump = storage.jump or {enabled = false, positions = {}}

-- atalho
local jumpPositions = storage.jump.positions

-- vamos converter pos em uma string, pra saber quais pos já estão salvas
local function posToString(pos)
  return pos.x..pos.y..pos.z
end

local function saveJumpPosition(pos)
  jumpPositions[posToString(pos)] = pos
end

local function markPos(pos)
  local tile = g_map.getTile(pos)
  if tile then
    tile:setText(texts.tileText)
  end
end

local function markAll(reset)
  for _, pos in pairs(jumpPositions) do
    local tile = g_map.getTile(pos)
    if tile then
      tile:setText(reset and '' or texts.tileText)
    end
  end
end

local jumpMacro = macro(2132131,"test jump",function()end)

onTalk(function(name, level, mode, text, channelId, pos)
  if not jumpMacro:isOn() then return end
  if (name ~= player:getName()) then return end
  if (mode ~= texts.mode) then return end
  if not text:lower():find(texts.toFind:lower()) then return end
  saveJumpPosition(pos)
  markPos(pos)
end)

onPlayerPositionChange(function(pos)
  if not jumpMacro:isOn() then return end
  local tile = g_map.getTile(pos)
  if tile and tile:getText() == texts.tileText then
    say(texts.down)
    say(texts.up)
  end
  -- check new positions
  markAll()
end)

UI.Button("Clear All Positions",function()
  markAll(true)
  jumpPositions = {}
  storage.jump.positions = {}
end)