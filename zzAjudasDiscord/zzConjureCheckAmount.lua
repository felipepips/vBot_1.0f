local diamondArrowId = 25757
local arrowSpell = 'Exevo Gran Con Hur'
local arrowCheck = 200

macro(3600, "Diamond arrows", function()
  local arrows = itemAmount(diamondArrowId)

  if arrows < arrowCheck then
    return say(arrowSpell)
  end

end)