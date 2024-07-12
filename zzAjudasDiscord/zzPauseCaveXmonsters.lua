-- PAUSE CAVEBOT IF MORE THAN X MONSTERS ON SCREEN

--START CONFIG
local MONSTERS_TO_PAUSE = 4
local MONSTERS_TO_CONTINUE = 2
--END CONFIG

-- EN: don't edit below this line unless you know what you are doing.
-- PT: não mexa em nada daqui pra baixo, a não ser que saiba o que está fazendo.
-- ES: no toques en nada desde aquí, a menos que sepas lo que estás haciendo.

local bool = false
local pauseCave = macro(300,"Wait Kill",function()
  local monsters = 0
  for s, spec in pairs(getSpectators(false)) do
    if spec:isMonster() then 
      monsters = monsters + 1
      if monsters >= MONSTERS_TO_PAUSE then
        CaveBot.setOff()
        bool = true
        return
      end
    end
  end
  if not bool or monsters > MONSTERS_TO_CONTINUE then return end
  CaveBot.setOn()
  bool = false
end)