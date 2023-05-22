setDefaultTab("Main")

-- allows to test/edit bot lua scripts ingame, you can have multiple scripts like this, just change storage.ingame_lua
local btIn = UI.Button("In-Game Script Editor", function(newText)
  UI.MultilineEditorWindow(storage.ingame_hotkeys or "", {title="In-Game Macro/Script Editor", description="You can add your custom scripts here"}, function(text)
    storage.ingame_hotkeys = text
    reload()
  end)
end)
btIn:setImageColor('#2de0d7')
    
for _, scripts in pairs({storage.ingame_hotkeys}) do
  if type(scripts) == "string" and scripts:len() > 3 then
    UI.Separator()
    local label = UI.Label("In-Game Scripts:")
    label:setColor('#9dd1ce')
    label:setFont('verdana-11px-rounded')
    local status, result = pcall(function()
      assert(load(scripts, "ingame_editor"))()
    end)
    if not status then 
      error("Ingame editor error:\n" .. result)
    end
  end
end

UI.Separator()