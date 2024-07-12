[[This tutorial teaches how to change the way vBot saves bot profiles, with these modifications you can have individual settings for each character.]]
--(inspired by https://trainorcreations.com/coding/otclient/14)

[[First, we need to change *CLIENT* installation folder. You have to CLOSE ALL OPENED CLIENTS]]

-- 1. Open file modules\game_bot\bot.lua
-- 2. Find this part of the code: (around lines 191~208)
  [[START HERE]]
    botStorage = {}

    local path = "/bot/" .. configName .. "/storage/"
    if not g_resources.directoryExists(path) then
      g_resources.makeDir(path)
    end

    botStorageFile = path.."profile_" .. g_settings.getNumber('profile') .. ".json"
    if g_resources.fileExists(botStorageFile) then
      local status, result = pcall(function() 
        return json.decode(g_resources.readFileContents(botStorageFile)) 
      end)
      if not status then
        return onError("Error while reading storage (" .. botStorageFile .. "). To fix this problem you can delete storage.json. Details: " .. result)
      end
      botStorage = result
    end
  [[END HERE]]

  
-- 3. And change to:
  [[START HERE]]
    botStorage = {}
    local playerName = g_game.getLocalPlayer():getName()

    local path = "/bot/" .. configName .. "/vBot_configs/"..playerName.."/"
    if not g_resources.directoryExists(path) then
      g_resources.makeDir(path)
    end

    botStorageFile = path.."General.json"

    if g_resources.fileExists(botStorageFile) then
      local status, result = pcall(function() 
        return json.decode(g_resources.readFileContents(botStorageFile)) 
      end)
      if not status then
        return onError("Error while reading storage (" .. botStorageFile .. ").\nDelete this file and try again.\nDetails: " .. result)
      end
      botStorage = result
    end
  [[END HERE]]


[[Now we gonna make some changes on *BOT FOLDER*, something like: C:\Users\user\AppData\Roaming\OTClientV8\otclientv8\bot\vBot_4.8]]

-- 4. Open file vBot_4.8\vBot\configs.lua

-- 5. Search for this part of the code (around lines 8~28):
  [[START HERE]]
    if not g_resources.directoryExists("/bot/".. configName .."/vBot_configs/") then
      g_resources.makeDir("/bot/".. configName .."/vBot_configs/")
    end

    -- make profile dirs
    for i=1,10 do
      local path = "/bot/".. configName .."/vBot_configs/profile_"..i
      if not g_resources.directoryExists(path) then
        g_resources.makeDir(path)
      end
    end

    local profile = g_settings.getNumber('profile')

    HealBotConfig = {}
    local healBotFile = "/bot/" .. configName .. "/vBot_configs/profile_".. profile .. "/HealBot.json"
    AttackBotConfig = {}
    local attackBotFile = "/bot/" .. configName .. "/vBot_configs/profile_".. profile .. "/AttackBot.json"
    SuppliesConfig = {}
    local suppliesFile = "/bot/" .. configName .. "/vBot_configs/profile_".. profile .. "/Supplies.json"
  [[END HERE]]

-- 6. And change to:
  [[START HERE]]
    if not g_resources.directoryExists("/bot/".. configName .."/vBot_configs/".. name() .."/") then
      g_resources.makeDir("/bot/".. configName .."/vBot_configs/".. name() .."/")
    end

    -- make profile dirs
    local path = "/bot/".. configName .."/vBot_configs/".. name() .."/"
    if not g_resources.directoryExists(path) then
      g_resources.makeDir(path)
    end

    HealBotConfig = {}
    local healBotFile = path.."HealBot.json"
    AttackBotConfig = {}
    local attackBotFile = path.."AttackBot.json"
    SuppliesConfig = {}
    local suppliesFile = path.."Supplies.json"
    SellConfig = {}
    local sellFile = path.."SellItems.json"
  [[END HERE]]
