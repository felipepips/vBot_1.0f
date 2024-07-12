-- -- START CONFIG
-- local LEVEL_TO_RESET = 500000
-- local GO_TO_LABEL = 'reset'
-- -- END CONFIG

-- local panel = modules.game_skills.skillsWindow.contentsPanel
-- local child = panel:getChildByIndex(1)
-- local value = child:getChildById('value')
-- local level = tonumber(value:getText())

-- if level >= LEVEL_TO_RESET then
--   gotoLabel(GO_TO_LABEL)
-- end

-- return true

--[[
local panel = modules.game_skills.skillsWindow.contentsPanel
local level = panel:getChildById('level')
local percent = level:getChildById('percent')
local tooltip = percent:getTooltip()
print(tooltip)
]]