-- SCREENSHOT/PRINTSCREEN WHEN LOW HP
-- saves PNG on C:\Users\userName\AppData\Roaming\OTClientV8\otclientv8\screenshots
--CONFIG HERE:
local MIN_HP_TO_SS = 20
--END CONFIG

macro(500, "ScreenShot Low HP", function()
    if hppercent() <= MIN_HP_TO_SS then 
        if not g_resources.directoryExists("/screenshots") then
            g_resources.makeDir("/screenshots")
        end
        doScreenshot("/screenshots/"..player:getName().. " - Low Health " ..os.date('%Y-%m-%d, %H.%M.%S').. ".png")
        delay(10000)
    end
end)