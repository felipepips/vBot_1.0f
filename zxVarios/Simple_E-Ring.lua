-- ENERY RING EQUIP BY HP%
local item = {eq = 3088, bp = 3051} -- id equipado e id na bp (se for o mesmo id, repetir)
local hp_config = {min = 50, max = 80} -- equipa no minimo, tira no max
local slot = SlotFinger
local oldVersions = true -- true: servers old (não equipa por hotkey) / false: servidores que pode equipar item por hotkey

-- NÃO MEXER
local hp = hp_config
local eRingMacro = macro(500,"Auto E-Ring",function()
  local life = hppercent()
  if life <= hp.min then
    -- equipar
    equipItem(getSlot(slot))
  elseif life >= hp.max then
    removeItem(getSlot(slot))
  end
end)

function equipItem(equipped)
  if not equipped or equipped:getId() ~= item.eq then
    if oldVersions then
      local find = findItem(item.bp)
      if find then
        moveToSlot(find,SlotFinger,1)
      end
    else
      g_game.equipItemId(item.bp)
    end
  end
end

function removeItem(equipped)
  if equipped and equipped:getId() == item.eq then
    if oldVersions then
      moveToSlot(equipped,SlotBack,1)
    else
      g_game.equipItemId(item.eq)
    end
  end
end

-- ICONE PARA SWAP
addIcon("swapERing", {item=3051, text="Swap"}, eRingMacro)

-- ICONE PARA HOLD FULL
addIcon("holdERing", {item=3051, text="Hold"}, function(icon, isOn)
  if isOn then
    if eRingMacro:isOff() then
      eRingMacro:setOn()
    end
    hp = {min = 100, max = 101}
  else
    hp = hp_config
  end
end)