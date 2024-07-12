-- Auto Close Window, For Your Information
local window_name = "Name On The Top Of The Window"

macro(1000,"Auto Click OK", function()
  for i, rootW in pairs(g_ui.getRootWidget():getChildren()) do
    if string.find(rootW:getText():lower(), window_name:lower()) then
      if rootW.okButton then rootW.okButton.onClick() end
      delay(100)
      if rootW then rootW:hide() end
      delay(1000)
      break
    end
  end
end)

-- local windows = modules.game_textwindow.windows