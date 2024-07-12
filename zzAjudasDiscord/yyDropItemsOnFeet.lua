-- CaveBot Action / Function, Drop Items on Feet / House Deposit
-- START CONFIG
local itemList = {3188,6528,1235,1363}
local moveDelay = 500 -- in milliseconds
-- END CONFIG

local tag = "[House Deposit]\n"
local pos = player:getPosition()
local time = 500
for e, entry in pairs(itemList) do
  local amount = itemAmount(entry)
  if amount > 0 then
    print(tag.."Scheduled Dropping: " ..amount.. "x of Item ID: "..entry)
    for r = 1, math.ceil(amount / 100) do
      schedule(time,function()
        local item = findItem(entry)
        if item then
          g_game.move(item,pos,item:getCount())
        end
      end)
      time = time + moveDelay
    end
  end
end
time = time + moveDelay
schedule(time,function() warn(tag.."Done!") end)
delay(time)
return true