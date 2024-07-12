local iconImageID = 23374
local manaId = 23374

local config = { -- each entry = 1 icon
  [25] = {icon = nil},
  [50] = {icon = nil},
  [75] = {icon = nil},
  [90] = {icon = nil},
}

storage.multiIcons = storage.multiIcons or 0
local last = tonumber(storage.multiIcons)

for e, entry in pairs(config) do
  entry.icon = addIcon("icon"..e,{item=iconImageID, movable=true, text=e.."%"}, function(w,on)
    for i, item in pairs(config) do
      if item.icon then
        item.icon.setOn(false)
      end
    end
    if on then
      w:setOn()
      storage.multiIcons = e
    else
      storage.multiIcons = 0
    end
  end)
  entry.icon.text:setFont("verdana-11px-rounded")
end

if config[last] then
  storage.multiIcons = last
  config[last].icon.setOn(true)
end

macro(250,function()
  if storage.multiIcons == 0 then return end
  if manapercent() <= storage.multiIcons then
    useWith(manaId,player)
  end
end)