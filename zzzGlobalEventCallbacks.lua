-- Check Last Balance
storage.balance = storage.balance or 0
storage.balanceText = storage.balanceText or ""

-- onTextMessage(function(mode, text)
--     print("Global onTextMessage Mode: "..mode.." Text: "..text)
-- end)

-- onTalk(function(name, level, mode, text, channelId, pos)
--   local posText = pos and " Pos: "..pos.x.." "..pos.y.." "..pos.x or ""
--   print("Global onTalk - Name: "..name.." Level: "..level.." Mode: "..mode.." Text: "..text.." ChannelId: "..channelId..posText)
-- end)

onTalk(function(name, level, mode, text, channelId, pos)
    -- local posText = pos and " Pos: "..pos.x.." "..pos.y.." "..pos.x or ""
    -- print("Global onTalk - Name: "..name.." Level: "..level.." Mode: "..mode.." Text: "..text.." ChannelId: "..channelId..posText)
    
    -- Check Last Balance
    if level == 0 and string.find(text, "Your account balance is") then
        local textBalance = text
        textBalance = string.split(textBalance, "account balance is ")[2]
        textBalance = string.split(textBalance, " gold")[1]
        storage.balance = tonumber(textBalance)
        if storage.balance >= 1000000 then -- mais que 1kk
            local txt = textBalance
            local len = txt:len()
            if len > 9 then
                txt = txt:sub(1,len-9).."kkk"
            elseif len > 8 then
                txt = txt:sub(1,3).."kk"
            elseif len > 7 then
                txt = txt:sub(1,2)..","..txt:sub(3,3).."kk"
            elseif len > 6 then
                txt = txt:sub(1,1)..","..txt:sub(2,3).."kk"
            end
            textBalance = txt
        end
        storage.balanceText = textBalance
    end

end)

-- onMouseRelease(function(mousePos, mouseButton)
--   warn("MouseRelease: ".. mouseButton)
-- end)

-- onMousePress(function(mousePos, mouseButton)
--   warn("MousePress: ".. mouseButton)
-- end)