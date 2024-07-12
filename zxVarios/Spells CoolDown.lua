local config = {
  textModes = {43,44}
}

local icons = {
  size = {90,30},
  font = 'verdana-11px-rounded',
  colorOk = 'green',
  colorCd = 'yellow',
}

local spells = {
  ['exura vita'] = {cd = 10000},
  ['utani gran hur'] = {cd = 6000}, -- 1000 = 1seg
}

local cdMacro = macro(100,function()
  for name, spell in pairs(spells) do
    if spell.icon then
      if not spell.last or (spell.last + spell.cd < now) then
        spell.icon.text:setText(name.."\n".."OK")
        spell.icon.text:setColor(icons.colorOk)
      else
        spell.icon.text:setText(name.."\n"..string.format("%.1f",(spell.cd - (now - spell.last)) / 1000))
        spell.icon.text:setColor(icons.colorCd)
      end
    end
  end
end)

-- criar icones
for name, spell in pairs(spells) do
  local i = addIcon(("spellIcon"..name),{text=name,switchable=false},function() say(name) end)
  i:setFont(icons.font)
  i:setSize({width = icons.size[1], height = icons.size[2]})
  spell.icon = i
end

-- callback
local pName = player:getName()
onTalk(function(name, level, mode, text, channelId, pos)
  if name ~= pName then return end
  if not table.find(config.textModes,mode) then return end
  local spell = spells[text:lower()]
  if not spell then return end
  spell.last = now
end)