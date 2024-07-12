-- START CONFIG
local minStamina = 43 -- in hours
-- END CONFIG

local function loginNext()
  modules.client_entergame.EnterGame.openWindow()

  local rwPanel = g_ui.getRootWidget():getChildById('charactersWindow')
  local buttonsPanel = rwPanel:getChildById('characters')

  if buttonsPanel then
    local childs = #buttonsPanel:getChildren()
    local focused = buttonsPanel:getFocusedChild()
    local fIndex = buttonsPanel:getChildIndex(focused)
    if fIndex == childs then
      buttonsPanel:focusChild(buttonsPanel:getFirstChild())
    else
      buttonsPanel:focusNextChild()
    end

    rwPanel:onEnter()
  end
end

macro(1000,"Login Next Character",function()
  if isInPz() then
    if stamina() < (minStamina * 60) then
      loginNext()
      delay(10000)
    end
  end
end)