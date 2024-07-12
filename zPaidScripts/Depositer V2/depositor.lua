-- Substituir Arquivo cavebot/depositor.lua
-- De Preferência fazer um backup antes.

-- Replace File cavebot/depositor.lua
-- Make a backup of the original file before.

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

-- Core Information
local stName = "DepositerV2"
storage[stName] = storage[stName] or {
  depositItems = {3079},
  depositContainers = {2869},
  sOld = g_game.getClientVersion() < 960,
  sDepositAll = false,
  sDelay = 350,
  sDepotName = "Depot chest"
}
local config = storage[stName]

-- Misc Info
local buttonName = "Deposit V2"
local actionName = "depositer"
local tag = "[CaveBot Depositer]"
local description = "House - BP on floor;\nDepot - BP inside Depot Chest;\nyes/no to reopen loot containers.\n\nExample: house, yes / house, no" 

local function log(text)
  print(os.date('%H:%M ') .. player:getName() .. " - " .. tag .. ": " .. text)
  statusMessage(tag .. ": " .. text)
end

-- Extension Start
CaveBot.Extensions.Depositer = {}

-- Temporary Vars
local depositItems = {}
local ready = false
local reach = 0
local deposited = false
local destination = nil
local time = 0
local reopenedLootContainers = false
local closedLootContainers = false
local firstLoot = nil

CaveBot.Extensions.Depositer.setup = function()
	local function setAll()
    config.lootContainers = CaveBot.GetLootContainers()
    depositItems = table.copy(config.depositItems)
    if config.sDepositAll then
      for e, entry in pairs(CaveBot.GetLootItems()) do
        table.insert(depositItems,entry)
      end
    end
	end

	local function closeLootContainers()
		for c, container in pairs(g_game.getContainers()) do
			local contId = container:getContainerItem():getId()
			if table.find(config.lootContainers,contId) then
				g_game.close(container)
			end
		end
	end

  local function openLootContainer(first)
    for c, container in pairs(g_game.getContainers()) do
			local contId = container:getContainerItem():getId()
			if table.find(config.lootContainers,contId) or first then
        for i, item in ipairs(container:getItems()) do
          if item:isContainer() and table.find(config.lootContainers,item:getId()) then
            if first then firstLoot = item end
            local prev = nil
            if not first then
              prev = container
            end
            return g_game.open(item, prev)
          end
        end
			end
		end
    return false
  end

  local function isDepositContainer(container)
		return table.find(config.depositContainers, container:getContainerItem():getId())
	end

	local function hasDepositItems()
		for _, container in pairs(g_game.getContainers()) do
			local name = container:getName():lower()
			if not name:find("depot") and not name:find("locker") and not isDepositContainer(container) then
				for _, item in pairs(container:getItems()) do
					local id = item:getId()
					if table.find(depositItems, id) then
						return true
					end
				end
			end
		end
	end
	
	local function resetCache(reopen)
    -- Reopen Loot Container
		if reopen then 
			closeLootContainers()
      if firstLoot then
        local last = firstLoot
        schedule(config.sDelay,function()
          g_game.open(last,nil)
        end)
      end
      CaveBot.delay(config.sDelay * 2)
		end

    -- Reset Vars
    depositItems = {}
    ready = false
    deposited = false
    reach = 0
		destination = nil
		time = 0
		reopenedLootContainers = false
		closedLootContainers = false
		firstLoot = nil
    log("Cache Reseted")

		if storage.caveBot.backStop then
			storage.caveBot.backStop = false
      log("Back & Stop - Setting OFF CaveBot")
			CaveBot.setOff()
		elseif storage.caveBot.backTrainers then
			storage.caveBot.backTrainers = false
      log("Going label: toTrainers")
			CaveBot.gotoLabel('toTrainers')
		elseif storage.caveBot.backOffline then
			storage.caveBot.backOffline = false
      log("Going label: toOfflineTraining")
			CaveBot.gotoLabel('toOfflineTraining')
		end

    return true
	end
	
	CaveBot.registerAction(actionName, "red", function(value, retries)
		
    -- Lets get things ready
		if not ready then
      setAll()
      ready = true
      return "retry"
    end

    -- Check Parameters
		local val = string.split(value, ",")
    local depot = true
    local reopen = true
		if #val ~= 2 then 
		  warn(tag..": Incorrect parameters, it should be house/depot, yes/no")
		  return false 
		else
		  depot = val[1]:trim():lower() == 'depot'
		  reopen = val[2]:trim():lower() == 'yes'
		end

    -- Check Configs
		if not depositItems[1] then
      log("Items to deposit not configured")
      return false
    end

		if config.sOld and not config.depositContainers[1] then
      log("Containers to deposit not configured")
      return false
    end

		-- Check Retries
		if retries > 999 then
      log("Actions limit reached, proceeding")
			resetCache(reopen)
			return false 
		end
    
    -- Auxiliar 'delay'
    local wait = g_game.getPing() > 100 and (g_game.getPing() * 4) or config.sDelay
    if time > now then return "retry" end

		-- Close / Open First Loot Containers
    if reopen and (not closedLootContainers or not reopenedLootContainers) then
      if not closedLootContainers then
        closeLootContainers()
        closedLootContainers = true
      else
        openLootContainer(true)
        reopenedLootContainers = true
      end
      delay(wait)
      return "retry"
    end

    -- Check if there's some item to deposit or next loot container to open
    if not hasDepositItems() then
      if reopen and openLootContainer() then
        delay(wait)
        return "retry"
      end
      -- No items to deposit
      log(deposited and "No More Items to Deposit." or "No Items to Deposit.")
      return resetCache(reopen)
    end

    -- Reach and open depot 
    local chest = getContainerByName(config.sDepotName)
    if depot and not chest then
      local locker = getContainerByName("Locker")
      if not locker then
        CaveBot.ReachDepot()
        if reach < 10 then
          reach = reach + 1
          return "retry"
        else
          CaveBot.OpenLocker()
        end
      elseif not chest then
        CaveBot.OpenDepotChest()
      end
      time = now + (wait * 2)
      return "retry"
    end

    -- Let's check for destination
    if destination and containerIsFull(destination) then destination = nil end
    local depositCont = config.depositContainers
    if (config.sOld or not depot) and not destination then
      -- First look for a container to deposit with space
      for e, entry in pairs(depositCont) do
        local dest = getContainerByItem(entry,true)
        if dest then
          destination = dest
          return "retry"
        end
      end
      -- If we don't find, let's check if there's another container to open
      for e, entry in pairs(depositCont) do
        local dest = getContainerByItem(entry)
        if dest then
          for i, item in ipairs(dest:getItems()) do
            if table.find(depositCont,item:getId()) then
              g_game.open(item,dest)
              delay(wait)
              return "retry"
            end
          end
        end
      end
      -- 'House'
      if not depot then
        local max_distance = 5
        for x = -max_distance, max_distance do
          for y = -max_distance, max_distance do
            local toPos = pos()
            toPos.x, toPos.y = toPos.x + x, toPos.y + y
            local tile = g_map.getTile(toPos)
            local path = findPath(pos(), toPos, max_distance, {ignoreNonPathable = false, precision = 1})
            if tile and path then
              local top = tile:getTopUseThing()
              if top then
                if table.find(depositCont,top:getId()) then
                  g_game.use(top)
                  delay((#path * wait) + wait)
                  return "retry"
                end
              end
            end
          end
        end
      else
        -- 'Depot'
        if chest then
          for i, item in ipairs(chest:getItems()) do
            if table.find(depositCont,item:getId()) then
              g_game.open(item,nil)
              delay(wait)
              return "retry"
            end
          end
        end
      end

      -- Didn't find destination, we done
      log("No Destination Found")
      return resetCache(reopen)
    end

    -- Start deposit
    for c, container in pairs(g_game:getContainers()) do
      if not table.find(depositCont,container:getContainerItem():getId()) then
        for i, item in ipairs(container:getItems()) do
          if table.find(depositItems,item:getId()) then
            if config.sOld then -- Old Versions
              g_game.move(item, destination:getSlotPosition(destination:getItemsCount()), item:getCount())
            else -- New Versions
              destination = destination or getContainerByName(config.sDepotName)
              if not destination then return "retry" end
              -- local index = item:isStackable() and 1 or 0
              local index = getStashingIndex(id) or (item:isStackable() and 1 or 0)
              CaveBot.StashItem(item, index, destination)
            end
            delay(wait)
            deposited = true
            log("Deposited "..item:getCount().."x item id: "..item:getId())
            return "retry"
          end
        end
      end
    end

    -- Finish
    log("Sucess! Done.")
		return resetCache(reopen)
	end)

	CaveBot.Editor.registerAction(actionName, buttonName, {
		value="depot, no",
		title=buttonName,
		description=description,
		validation="(depot|Depot|DEPOT|house|House|HOUSE), (yes|Yes|YES|no|No|NO)"
		}
	)
end

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL