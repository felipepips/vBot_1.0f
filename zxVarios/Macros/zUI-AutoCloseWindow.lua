-- Auto Close Window, For Your Information
local window_name = "Show Text"

macro(1000,"Auto Click OK", function()
  for i, rootW in pairs(g_ui.getRootWidget():getChildren()) do
    if string.find(rootW:getText():lower(), window_name:lower()) then
      if rootW.okButton then rootW.okButton.onClick() end
      if rootW then rootW:hide() end
      break
    end
  end
end)

-- WINDOW TEXT EDIT
singlehotkey("F11","Teste FYI", function()
  local windows = modules.game_textwindow.windows
  for _, window in pairs(windows) do
    warn(window.text:getText())
    window.okButton.onClick()
  end
end)

-- READ TEXT IN FYI WINDOW / FOR YOUR INFORMATION
singlehotkey("F11","Teste FYI", function()
  for _, rootW in pairs(g_ui.getRootWidget():getChildren()) do
    local title = rootW:getText()
    if title == "For Your Information" then
      local body = rootW:getChildByIndex(1)
      local content = body:getText()
      for e, entry in pairs(content:split("\n")) do
        if entry:find("Power Ranger") then
          talkPrivate(player:getName(),entry:trim())
        end
      end
    end
  end
end)