local min_mana = 60 -- min mp % to make runes and use MFs
local rune_spell = 'adori gran'
local min_cap = 1 -- se estiver abaixo de x de cap, para de runar
local ids = {
  locker_ground = {3497,3498,3499,3500}, -- ground locker
  locker = 3499, -- open locker
  chest = 3502, -- open chest
  bp_runes = 2869, -- id da bp pra depositar as runas
  bp_mf = 2868, -- id da bp onde fica as mf
  mf = 268, -- id da mf
  runes = {3155,3160,3198}, -- id das runas prontas, pra depositar
}

local openDelay = 500
local ignore = {ids.locker,ids.chest,ids.bp_runes,ids.bp_mf} -- não mexer
macro(250,"Trainer RuneMaker",function()
  -- ABRIR MAIN BP
  local mainItem = getBack()
  if not mainItem then
    return -- sem bp no char??
  end
  if not getContainerByItem(mainItem:getId()) then
    delay(openDelay)
    return g_game.use(mainItem)
  end
  -- ABRIR LOCKER
  local locker = getContainerByItem(ids.locker)
  if not locker then
    for t, tile in pairs(getNearTiles(pos())) do
      for i, item in pairs(tile:getItems()) do
        if table.find(ids.locker_ground,item:getId()) then
          delay(openDelay)
          return g_game.use(item)
        end
      end
    end
    return -- sem locker, parar
  end
  -- ABRIR CHEST
  local chest = getContainerByItem(ids.chest)
  if not chest then
    for i, item in ipairs(locker:getItems()) do
      if item:getId() == ids.chest then
        delay(openDelay)
        return g_game.open(item,nil)
      end
    end
    return -- sem chest, parar
  end
  -- ABRIR BP DE MF
  local manabp = getContainerByItem(ids.bp_mf)
  if not manabp then
    for i, item in ipairs(chest:getItems()) do
      if item:getId() == ids.bp_mf then
        delay(openDelay)
        return g_game.open(item,nil)
      end
    end
  end
  -- ABRIR BP PARA DEPOSITAR
  local depositbp = getContainerByItem(ids.bp_runes)
  if not depositbp then
    for i, item in ipairs(chest:getItems()) do
      if item:getId() == ids.bp_runes then
        delay(openDelay)
        return g_game.open(item,nil)
      end
    end
  end
  -- VER SE TEM ESPAÇO NA BP PRA DEPOSITAR
  local dest
  if depositbp then
    local slots = depositbp:getCapacity()
    local items = depositbp:getItems()
    if slots > #items then
      -- tem espaço
      dest = depositbp:getSlotPosition(slots)
    else
      -- não tem espaço
      for i, item in ipairs(items) do
        if item:getId() == ids.bp_runes then
          -- abre a prox
          delay(openDelay)
          return g_game.open(item,depositbp)
        end
      end
      return -- sem mais bp para depositar, parar
    end
  end
  -- VER SE TEM RUNA PRA DEPOSITAR
  for c, cont in pairs(getContainers()) do
    if not table.find(ignore,cont:getContainerItem():getId()) then
      for i, item in ipairs(cont:getItems()) do
        if table.find(ids.runes,item:getId()) and item:getCount() == 100 then
          delay(openDelay)
          return g_game.move(item,dest,100)
        end
      end
    end
  end

  -- VER SE TEM MANA PRA RUNAR
  if manapercent() > min_mana then
    -- tem, verificar se tem cap
    if freecap() > min_cap then
      return say(rune_spell)
    end
  else
    -- se não, usar mf
    local find = findItem(ids.mf)
    if find then
      -- achou mf
      return useWith(find,player)
    else
      -- não achou, procurar mais
      for i, item in ipairs(manabp:getItems()) do
        if item:getId() == ids.bp_mf then
          -- abre a prox
          return g_game.open(item,manabp)
        end
      end
    end
  end
end)

talkPrivate(player:getName(),getContainerByName("Locker"):getContainerItem():getId())