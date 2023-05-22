-- local version = "4.8"
-- local currentVersion
-- local available = false

-- storage.checkVersion = storage.checkVersion or 0

-- -- check max once per 12hours
-- if os.time() > storage.checkVersion + (12 * 60 * 60) then

--     storage.checkVersion = os.time()
    
--     HTTP.get("https://raw.githubusercontent.com/Vithrax/vBot/main/vBot/version.txt", function(data, err)
--         if err then
--           warn("[vBot updater]: Unable to check version:\n" .. err)
--           return
--         end

--         currentVersion = data
--         available = true
--     end)

-- end

-- UI.Label("vBot v".. version .." \n Vithrax#5814")
-- UI.Button("Official OTCv8 Discord!", function() g_platform.openUrl("https://discord.gg/yhqBE4A") end)
-- UI.Separator()

-- schedule(5000, function()

--     if not available then return end
--     if currentVersion ~= version then
        
--         UI.Separator()
--         UI.Label("New vBot is available for download! v"..currentVersion)
--         UI.Button("Go to vBot GitHub Page", function() g_platform.openUrl("https://github.com/Vithrax/vBot") end)
--         UI.Separator()
        
--     end

-- end)

local texts = {'Revamped vBot by F.Almeida','Based on vBot 4.8 by Vithrax'}
for e, entry in pairs(texts) do
  local label = UI.Label(entry)
  label:setFont('verdana-11px-rounded')
  label:setColor('#9dd1ce')
end

local btDisc = UI.Button("Official OTCv8 Discord", function() g_platform.openUrl("https://discord.gg/yhqBE4A") end)
btDisc:setColor("#9dd1ce")
btDisc:setFont('verdana-11px-rounded')
UI.Separator()


Global = {}
Global.useIds = { 34847, 1764, 21051, 30823, 6264, 5282, 20453, 20454, 20474, 11708, 11705, 
6257, 6256, 2772, 27260, 2773, 1632, 1633, 1948, 435, 6252, 6253, 5007, 4911, 
1629, 1630, 5108, 5107, 5281, 1968, 435, 1948, 5542, 31116, 31120, 30742, 31115, 
31118, 20474, 5737, 5736, 5734, 5733, 31202, 31228, 31199, 31200, 33262, 30824, 
5125, 5126, 5116, 5117, 8257, 8258, 8255, 8256, 5120, 30777, 30776, 23873, 23877,
5736, 6264, 31262, 31130, 31129, 6250, 6249, 5122, 30049, 7131, 7132, 7727 }
Global.shovelIds = { 606, 593, 867, 608 }
Global.ropeIds = { 17238, 12202, 12935, 386, 421, 21966, 14238 }
Global.macheteIds = { 2130, 3696 }
Global.scytheIds = { 3653 }

Global.PVPoffsetDirections = {
  [North] = { 0, -2 },
  [East] = { 2, 0 },
  [South] = { 0, 2 },
  [West] = { -2, 0 },
  [NorthEast] = { 1, -1 },
  [SouthEast] = { 1, 1 },
  [SouthWest] = { -1, 1 },
  [NorthWest] = { -1, -1 }
}