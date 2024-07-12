-- PRIVATE MESSAGE IF PLAYER ATTACK - PK

local friendName = "Jesus Christ"
local message = "Please help me"

macro(100,"Player Attacked PK",function() 
  for s, spec in pairs(getSpectators(false)) do
    if spec ~= player and spec:isPlayer() and spec:isTimedSquareVisible() and spec:getShield() < 3 then
      talkPrivate(friendName,message)
      delay(1500)
    end
  end
end)