-- esse script foi feito sob encomenda para um server que tinha um sistema de "trade offline"

-- START CONFIG
-- MACRO CONFIG
local sellSlot = 10 -- InventorySlotAmmo
local moveDelay = 500
local talkDelay = 3000
-- TRASH CONFIG
local trash_bin_id = 2526
local trash_items = {3504,3507} -- PRIMEIRO O ID DA PARCEL (SEMPRE), depois qq coisa q for lixo (label, por exemplo)
-- CONTAINERS CONFIG
local mainBp = 8860
local lockerId = 3497
-- FILE CONFIG
local fileName = "TradeOffStorage.json"
local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text
local filePath = "/bot/" .. configName .. "/storage/"..fileName
-- MISC CONFIG
local tag = "[TradeOff]\n"
-- END CONFIG


-- FUNCTIONS
local function stash(item,dest)
  return g_game.move(item,dest:getSlotPosition(dest:getCapacity()),item:getCount())
end

macro(moveDelay,"TradeOff - JSON",function(m)
  -- CHECK CONTAINERS
  local main = getContainerByItem(mainBp,true)
  local inbox = getContainerByItem(lockerId)
  local trashBin = findItemOnGround(trash_bin_id)

  if not main then
    warn(tag.."Main BP nao encontrada")
    return delay(5000)
  end
  if not inbox then
    warn(tag.."Locker nao esta aberto")
    return delay(5000)
  end
  if not trashBin then
    warn(tag.."Lixeira nao encontrada")
    return delay(5000)
  end
  
  -- TAKE ITEMS FROM INSIDE OPENED PARCELS
  local parcel = getContainerByItem(trash_items[1])
  if parcel then
    for i, item in ipairs(parcel:getItems()) do
      if not table.find(trash_items,item:getId()) then
        return stash(item,main)
      end
    end
    -- NO MORE ITEMS TO REMOVE FROM INSIDE PARCEL, CLOSE IT
    return g_game.close(parcel)
  end

  -- THROW TRASH AWAY FROM MAIN BP
  for i, item in ipairs(main:getItems()) do
    if table.find(trash_items,item:getId()) then
      return g_game.move(item,trashBin:getPosition(),item:getCount())
    end
  end
  
  -- OPEN PARCELS INSIDE INBOX AND MOVE IT TO MAIN BP
  for i, item in ipairs(inbox:getItems()) do
    if table.find(trash_items,item:getId()) and item:isContainer() then
      g_game.open(item,nil)
      schedule(moveDelay,function()
        stash(item,main)
      end)
      return delay(moveDelay * 3)
    end
  end

  -- READ JSON FILE
  local fileTable = nil
  if g_resources.fileExists(filePath) then
    local status, result = pcall(function() 
      return json.decode(g_resources.readFileContents(filePath)) 
    end)
    if not status then
      return onError(tag.."Error Loading: " .. result)
    end
    fileTable = result
  else
    warn(tag.."JSON not found")
    return delay(5000)
  end
  if not fileTable then return end

  -- EXECUTE ACTIONS
  local nextAction = fileTable["actionList"][1]
  if not nextAction or type(nextAction) ~= 'table' then
    warn(tag.."No More Actions")
    return delay(5000) -- pause to save resources
  end
  local toDo = {}
  toDo.act = nextAction['action']
  toDo.cmd = nextAction['command']
  -- REMOVE
  if toDo.act == "remove" then
    say(toDo.cmd)
    delay(talkDelay)
  -- SELL
  elseif toDo.act == "create" then
    local id = tonumber(nextAction['game_id'])
    local slotItem = getSlot(sellSlot)
    if slotItem then
      if slotItem:getId() == id then -- ITEM ALREADY IN SLOT
        say(toDo.cmd)
        schedule(talkDelay,function()
          say(toDo.cmd)
        end)
        delay(talkDelay * 2)
      else
        return stash(slotItem,main) -- OTHER ITEM IN SLOT, REMOVE
      end
    else
      local find = findItem(id)
      if find then
        delay(talkDelay * 2)
        return moveToSlot(find,sellSlot,find:getCount()) -- EQUIP ITEM IN SLOT
      else
        warn(tag.."ID to sell: "..id.." not found")
        delay(5000)
      end
    end
  else
    warn(tag.."Unknow Action: "..toDo.act)
    delay(5000)
  end
  table.remove(fileTable["actionList"],1)

  -- WRITE JSON FILE AGAIN
  local status, result = pcall(function() 
    return json.encode(fileTable, 2) 
  end)
  if not status then
    return onError(tag.."Error Saving: " .. result)
  end
  g_resources.writeFileContents(filePath, result)
end)