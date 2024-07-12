-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

-- SEND PARCEL // CAVEBOT FUNCTION

-- START CONFIG
local move_delay = 600
local maxDistance = 3 -- sqms (for npc and mailbox)
-- SEND CONFIG
local player_name_to_send = "TesteTesteTeste"
local city_name_to_send = "Thais"
-- ITEMS CONFIG
local parcel_id = 3503
local label_id = 3507
local mailbox_id = 3501
-- NPC CONFIG
local npcNames = {"Benjamin","Liane","Redward"}
local oldVersions = false -- true = buy by 'hi, buy parcel, yes' / false = buy by 'hi, trade'
-- END CONFIG

local tag = "[Send Parcel]"
storage.sendParcel = storage.sendParcel or {
  labelOk = false
}

local labelTxt = player_name_to_send.."\n"..city_name_to_send
local config = storage.sendParcel
local items_to_send = storage["SendParcel"].sendItems

-- START FUNCTION
local mailBox = findItemOnGround(mailbox_id)
if not mailBox then
  warn(tag.."\nMailBox not found")
  config.labelOk = false
  return false
end

local toSend = false
for e, entry in pairs(items_to_send) do
  if findItem(entry) then
    toSend = true
    break
  end
end

if not toSend then
  warn(tag.."\nNo more items to send")
  config.labelOk = false
  return false
end

local findParcel = findItem(parcel_id)
local findLabel = findItem(label_id)
if not findParcel or not findLabel then
  -- COMPRAR PARCEL
  for n, npcName in ipairs(npcNames) do
    local npc = getCreatureByName(npcName)
    if npc then
      local npcPos = npc:getPosition()
      if distanceFromPlayer(npcPos) > maxDistance then
        autoWalk(npcPos, 15, {precision=maxDistance})
        delay(move_delay)
        return "retry"
      end
      if oldVersions then
        local conversation = {"hi","buy parcel","yes"}
        local talkDelay = 2222 -- ms
        for i, msg in ipairs(conversation) do
          schedule(talkDelay * (i - 1), function()
            NPC.say(msg)
          end)
        end
        delay((#conversation * talkDelay) + move_delay)
        return "retry"
      else
        if not NPC.isTrading() then
          NPC.say("hi")
          NPC.say("trade")
          delay(move_delay * 2)
          return "retry"
        else
          local wait = 0
          if not findParcel then
            NPC.buy(parcel_id, 1)
            wait = move_delay
          end
          if not findLabel then
            schedule(wait,function()
              NPC.buy(label_id, 1)
            end)
            wait = wait + move_delay
          end
          schedule(wait,function()
            NPC.closeTrade()
          end)
          wait = wait + move_delay
          delay(wait)
          return "retry"
        end
      end
    end
  end
  warn(tag.."\nNPC not found")
  config.labelOk = false
  return false 
end

local openParcel = getContainerByItem(parcel_id)
if not openParcel then
  g_game.open(findParcel,nil)
  delay(move_delay)
  return "retry"
end

-- Label
if not config.labelOk then
  for i, item in ipairs(openParcel:getItems()) do
    if item:getId() == label_id then
      g_game.use(item)
      schedule(move_delay,function()
        local windows = modules.game_textwindow.windows
        for _, window in pairs(windows) do
          window.text:setText(labelTxt)
          schedule(move_delay,function()
            window.okButton.onClick()
            config.labelOk = true
          end)
        end
      end)
      delay(move_delay * 4)
      return "retry"
    end
  end
  g_game.move(findLabel,openParcel:getSlotPosition(openParcel:getCapacity()),1)
  delay(move_delay)
  return "retry"
end

local parcelFull = containerIsFull(openParcel)
if not parcelFull then
  for c, cont in pairs(getContainers()) do
    if cont:getContainerItem():getId() ~= parcel_id then
      for i, item in ipairs(cont:getItems()) do
        if table.find(items_to_send,item:getId()) then
          g_game.move(item,openParcel:getSlotPosition(openParcel:getCapacity()),item:getCount())
          delay(move_delay)
          return "retry"
        end
      end
    end
  end
end

-- last check on parcel/label
local labelOk2 = false 
for i, item in ipairs(openParcel:getItems()) do
  if item:getId() == label_id then
    labelOk2 = true
    break
  end
end
if not labelOk2 then
  config.labelOk = false
  return "retry"
end

-- SEND PARCEL
local mailPos = mailBox:getPosition()
local mailTile = g_map.getTile(mailPos)
local topMail = mailTile:getTopUseThing()
local diffDist = getDistanceBetween(pos(),mailPos)
if not mailTile:canShoot() or diffDist > maxDistance then
  autoWalk(mailPos, 30, {precision=1})
  delay(move_delay)
  return "retry"
end

if topMail:getId() ~= mailbox_id then
  g_game.move(topMail,player:getPosition(),topMail:getCount())
else
  g_game.move(findParcel,mailPos,1)
  config.labelOk = false
  print(os.date('%H:%M ') .. player:getName() .. " - " .. tag .. ": Parcel Sent to: " .. player_name_to_send)
  broadcastMessage(tag.."\nParcel Sent")
end

delay(move_delay)
return "retry"

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL