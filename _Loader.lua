-- load all otui files, order doesn't matter
local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text

local configFiles = g_resources.listDirectoryFiles("/bot/" .. configName .. "/vBot", true, false)
for i, file in ipairs(configFiles) do
  local ext = file:split(".")
  if ext[#ext]:lower() == "ui" or ext[#ext]:lower() == "otui" then
    g_ui.importStyle(file)
  end
end

local function loadScript(name)
  return dofile("/" .. name .. ".lua")
end

-- here you can set manually order of scripts
-- libraries should be loaded first
local luaFiles = {
  "vBot/main",
  "vBot/items",
  "vBot/vlib",
  "vBot/new_cavebot_lib",
  "vBot/configs", -- do not change this and above
  "vBot/extras",
  "vBot/extrasPvp",
  "vBot/cave_target_settings",
  "vBot/cavebot",
  "vBot/playerlist",
  "vBot/alarms",
  "vBot/AttackBot", -- last of major modules
  -- "vBot/BotServer",
  -- "vBot/combo",
  "vBot/Conditions",
  "vBot/Equipper",
  "vBot/friend_healer",
  "zFreeScripts/Spells/zAutoBuff",
  "vBot/HealBot",
  -- "vBot/Heal-Old",
  "vBot/mana_train",
  "vBot/Dropper",
  "zFreeScripts/Party/z_Auto-Party",
  "vBot/ContainerManager",
  "vBot/quiver_manager",
  "vBot/quiver_label",
  "vBot/tools",
  "vBot/antiRs",
  "vBot/depot_withdraw",
  "vBot/eat_food",
  "vBot/equip",
  "vBot/exeta",
  "vBot/analyzer",
  "vBot/spy_level",
  "vBot/supplies",
  "vBot/depositer_config",
  "vBot/npc_talk",
  "vBot/xeno_menu",
  "vBot/cavebot_control_panel",
  "zFreeScripts/Misc/SkillsHUD",
  "vBot/ingame_editor",
}

for i, file in ipairs(luaFiles) do
  loadScript(file)
end

setDefaultTab("Main")
local label = UI.Label("Custom Scripts:")
label:setColor('#9dd1ce')
label:setFont('verdana-11px-rounded')
UI.Separator()