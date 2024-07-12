loginNext = function()
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
  return true
end