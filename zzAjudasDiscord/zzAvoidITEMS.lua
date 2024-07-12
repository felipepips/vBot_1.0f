local replace_id = 2110
local mark_color = "red"
if not storage.avoid_items or type(storage.avoid_items) ~= "table" then
  storage.avoid_items = {2147,2145,2148,2146}
end

local avoidMacro = macro(10*60*1000,"Avoid Traps",function()
end)

local function parseItems(items)
  local parse = {}
  for e, entry in pairs(items) do
    local id = type(entry) == 'table' and entry.id or entry
    table.insert(parse,id)
  end
  return parse
end

local avoidContainer = UI.Container(function(widget, items)
  storage.avoid_items = parseItems(items)
end, true)
avoidContainer:setHeight(35)
avoidContainer:setItems(parseItems(storage.avoid_items))

local i = addIcon("qq",{text="Avoid\nTraps"}, avoidMacro)
i.text:setFont("verdana-11px-rounded")

onAddThing(function(tile, thing)
  if not avoidMacro:isOn() then return end
  if thing:isItem() then
    if not isOnTile(replace_id,tile) then
      local oldId = thing:getId()
      if table.find(storage.avoid_items,oldId) then
        local item = thing
        if thing:isGround() then
          local create = Item.create()
          tile:addThing(create,1)
          item = create
        end
        item:setId(replace_id)
        item:setMarked(mark_color)
      end
    end
  end
end)