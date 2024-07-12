local waitIfNotFound = false -- esperar se o player nao estiver na tela?
local onlyParty = true -- só espera quem está na party?
-- STORAGE
storage.waitFriends = storage.waitFriends or {dist = 5, text = ""}
local config = storage.waitFriends
local friends = {}
-- PARSE FRIENDS TEXT TO TABLE
local function parseFriendList()
  friends = {}
  for _, friend in pairs(config.text:split("\n")) do
    table.insert(friends,friend)
  end
end
parseFriendList()

-- MACRO
local paused = false
macro(250,"Wait Friends",function()
  local p = pos()
  for f, friend in pairs(friends) do
    local find = getCreatureByName(friend)
    if (not find and waitIfNotFound) or (find and (not onlyParty or find:getShield() > 2) and getDistanceBetween(p,find:getPosition()) > config.dist) then
      if not paused then
        paused = true
        delay(1000) -- tempo que vai ficar parado até começar a andar pros lados
        return CaveBot.setOff()
      else
        local wait = 0
        local step = 250 -- intervalo de cada passo
        for i = 0, 3 do
          schedule(wait,function()
            walk(i)
            schedule(wait+step,function()
              walk((i + 2) % 4)
            end)
          end)
          wait = wait + step + step
        end
        wait = wait + step
        delay(wait)
        return
      end
    end
  end
  if paused then
    paused = false
    CaveBot.setOn()
  end
end)

-- UI
UI.Label("Distance:")
addTextEdit("wfDist", config.dist, function(widget, text)
  config.dist = tonumber(text)
end)
UI.Button("Edit Friend List", function(newText)
  UI.MultilineEditorWindow(config.text or "", {title="Wait Friends List", description="Insert 1 friend in each line"},
  function(text)
    config.text = text
    parseFriendList()
  end)
end)