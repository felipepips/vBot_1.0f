g_ui.loadUIFromString([[
LOOTITEM < UIItem
  anchors.centerIn: parent
  size: 30 30
  background-color: black
  opacity: 0.85
  margin-top: -85
]])

local lootList = { -- td minusculo aqui
  ['meat'] = 3577,
  ['ham'] = 3582,
  ['cheese'] = 3607,
}

local function showLoot(lootList)
  for i, id in pairs(lootList) do
    local widget = UI.createWidget("LOOTITEM", g_ui.getRootWidget())
    widget:setMarginLeft(i * 50)
    widget:setItemId(id)
    schedule(3000, function()
      widget:hide()
    end)
  end
end

local function parseNames(namesList)
  local result = {}
  for _, name in pairs(namesList) do
    local id = lootList[name:lower()]
    if id then
      table.insert(result,id)
    end
  end
  showLoot(result)
end

onTextMessage(function(mode, text)
  -- EXEMPLO DE MSG = 'Loot of a bear: meat, ham.'
  if not text:find("Loot of") then return end
  local mob, loot = text:match("Loot of (.+)%: (.+)%.")
  if not loot then return end
  local names = {}
  if not loot:find(',') then
    table.insert(names,loot:trim())
  else
    for _, name in pairs(loot:split(',')) do
      table.insert(names,name:trim())
    end
  end
  parseNames(names)
end)
