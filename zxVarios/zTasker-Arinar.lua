local function print(message)
	broadcastMessage(message)
end
-- self.mousePos, MouseRightButton

macro(100,"descobrir right panel",function(m)
  -- print(taskButton:getId())
  -- taskButton.onClick()
  -- local childs = buttons2:getChildren()
  -- for c, child in ipairs(childs) do
  --   print(child:getId())
  -- end
  m:setOff()
end)

local function abrirJanela()
  local rPanel = modules.game_interface.getRightPanel()
  local buttons = rPanel:getChildById('buttons')
  local buttons2 = buttons.contentsPanel:getChildById('buttons')
  local taskButton = buttons2:getChildById('taskButton')
  taskButton:onMouseRelease(taskButton:getPosition(),MouseRightButton)
end

local function selecionarCategoria(category)
  local rw = g_ui.getRootWidget()
  local taskW = rw:getChildById("TaskUI")
  local cat = taskW:getChildById(category)
  cat.onClick()
end

local function selecionarTask(task)
  local rw = g_ui.getRootWidget()
  local taskW = rw:getChildById("TaskUI")
  local list = taskW:getChildById('ListBase')
  local tasks = list:getChildById('TaskList')
  local selected = tasks:getChildById(task)
  local bt = selected:getChildById('ViewIcon')
  if bt:getTooltip() == 'Accept Task' then
    bt:onClick()
  end
end

UI.Button("Abrir Janela",function()
  abrirJanela()
end)

UI.Button("Selecionar Categoria",function()
  selecionarCategoria('FiveTasks')
end)

UI.Button("Selecionar Task",function()
  selecionarTask('Emerald Scorpion_task')
end)

-- local rw = g_ui.getRootWidget()
-- local taskW = rw:getChildById("TaskUI")
-- local cat = taskW:getChildById(desired.category)
-- cat.onClick()
-- local list = taskW:getChildById('ListBase')
-- local tasks = list:getChildById('TaskList')
-- local task = tasks:getChildById('Emerald Scorpion_task')
-- local bt = task:getChildById('ViewIcon')
-- if bt:getTooltip() == 'Accept Task' then
--   bt:onClick()
-- end

--[[categorias
NormalTasks
HardTasks
HeroicTasks
LegendaryTasks
FiveTasks
SixTasks
]]

--[[outros
ListBase
LateralTop
LateralMid
LateralBottom
Topbase
CloseButton
Layer
MessageBase
]]