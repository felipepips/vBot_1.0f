UI.Separator()
local wepLabel = UI.Label("")
local check = false

local function checkWep()
  local weapon = getLeft()
  if weapon then
    check = true
    g_game.look(weapon)
  end
end
checkWep()

local m = macro(5000, "Check Imbuements", function()
    checkWep()
end)

onTextMessage(function(mode, text)
  if m:isOff() then return end
  if not check then return end 
  if not text:find("Imbuements:") then return end
  local regData = [[Imbuements: \(([^)]*)]]
  local re = regexMatch(text, regData)
  local imbuData = re[1][2]
  if imbuData then
    if imbuData:find("Vampirism") or imbuData:find("Void") then
      wepLabel:setText(imbuData)
      wepLabel:setColor("green")
    else
      wepLabel:setText("Attention, renew your imbue!")
      wepLabel:setColor("red")
      error("Attention, renew your imbue!")
    end
  end
  check = false
end)
UI.Separator()