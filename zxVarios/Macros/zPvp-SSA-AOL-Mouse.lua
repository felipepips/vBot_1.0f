-- AUTO EQUIP - AOL + SSA - MOUSE HOTKEY
local ssaMouseButton = 7 -- baixo
local ssaId = 3081
local aolMouseButton = {3,8} -- meio e cima
local aolId = 3057
-- END CONFIG
local ssaMacro = macro(787987489,"SSA Hotkey",function() end)
local aolMacro = macro(787987489,"AOL Hotkey",function() end)
modules.game_interface.gameRootPanel.onMouseRelease = function(widget, mousePos, mouseButton)
  if ssaMacro:isOn() and mouseButton == ssaMouseButton then
    local neck = getNeck()
    local find = findItem(ssaId)
    if not neck or neck:getId() ~= ssaId then
      moveToSlot(find, 2)
    end
  elseif aolMacro:isOn() and table.find(aolMouseButton,mouseButton) then
    local neck = getNeck()
    local find = findItem(aolId)
    if not neck or neck:getId() ~= aolId then
      moveToSlot(find, 2)
    end
  end
  return true
end