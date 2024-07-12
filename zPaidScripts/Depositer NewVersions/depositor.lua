-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

-- SCRIPT MADE BY F.Almeida#8019 - if you are reading this, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD
	
CaveBot.Extensions.Depositer = {}

local destination = nil
local time = 0
local itemsToDeposit = {}
local depositContainers = {}
local lootContainers = {}
local reopenedLootContainers = false
local closedLootContainers = false
local firstLoot = nil

-- for compatibility with deposit system
local panelName = "oldDepositConfig" 
local config = storage[panelName]
local oldVersion = g_game.getClientVersion() < 960 and true or false
local description = --oldVersion
--and 
"House - BP on floor;\nDepot - BP inside Depot Chest;\nyes/no to reopen loot containers.\n\nExample: house, yes / house, no" 
-- or 
-- "this script was made for older versions, restore original vbot to use it on new versions."

CaveBot.Extensions.Depositer.setup = function()
	local function setAll()
		--get Deposit Items
		--from new loot system
		if Sell and Sell.getDepositItems() then itemsToDeposit = Sell.getDepositItems() end
		--from deposit system
		if config.depositItems[1] then
			for e, entry in pairs(config.depositItems) do table.insert(itemsToDeposit,entry.id) end
		end

		--get deposit Containers
		--from new loot system
		if Sell and Sell.getDepositContainers() then depositContainers = Sell.getDepositContainers() end
		--from deposit system
		if config.depositContainers[1] then
			for e, entry in pairs(config.depositContainers) do table.insert(depositContainers,entry.id) end
		end

		--get loot Containers
		--from new loot system
		if Sell and Sell.getLootContainers() then lootContainers = Sell.getLootContainers() end
		--from default loot targetbot
		if CaveBot.GetLootContainers() then
			for e, entry in pairs(CaveBot.GetLootContainers()) do 
				table.insert(lootContainers,entry) 
			end
		end
	end

	local function closeLootContainers()
		for c, container in pairs(g_game:getContainers()) do
			local cId = container:getContainerItem():getId()
			if table.find(lootContainers,cId) then
				g_game.close(container)
			end
		end
	end
	
	local function resetCache(reopen)
		if reopen == "yes" then 
			closeLootContainers() 
			g_game.open(firstLoot)
		end

		destination = nil
		time = 0
		itemsToDeposit = {}
		depositContainers = {}
		lootContainers = {}
		reopenedLootContainers = false
		closedLootContainers = false
		firstLoot = nil

		if storage.caveBot.backStop then
			storage.caveBot.backStop = false
			print(os.date('%H:%M ') .. player:getName() .." - CaveBot[Depositer]: Back&Stop - Setting OFF CaveBot")
			CaveBot.setOff()
		elseif storage.caveBot.backTrainers then
			storage.caveBot.backTrainers = false
			print(os.date('%H:%M ') .. player:getName() .." - CaveBot[Depositer]: Going label: toTrainers")
			CaveBot.gotoLabel('toTrainers')
		elseif storage.caveBot.backOffline then
			storage.caveBot.backOffline = false
			print(os.date('%H:%M ') .. player:getName() .." - CaveBot[Depositer]: Going label: toOfflineTraining")
			CaveBot.gotoLabel('toOfflineTraining')
		elseif storage.runStorage and storage.runStorage.runIfAttacked then
			storage.runStorage.runIfAttacked = false
			if TargetBot and TargetBot.isOff() then TargetBot.setOn() end
			print(os.date('%H:%M ') .. player:getName() .." - CaveBot[Depositer]: Player Attack, going to label: stopTime")
			CaveBot.gotoLabel('stopTime')
		end
		print(os.date('%H:%M ') .. player:getName() .." - CaveBot[Depositer]: Cache Reseted")
	end

	local function haveSpace(container)
		if container:getItemsCount() < container:getCapacity() then return true end
	end

	local function isDepositContainer(container)
		if table.find(depositContainers, container:getContainerItem():getId()) then return true end
	end

	local function isDepositItem(item)
		if table.find(itemsToDeposit, item:getId()) then return true end
	end

	local function hasDepositItems()
		for _, container in pairs(g_game.getContainers()) do
			local name = container:getName():lower()
			if not name:find("depot") and not name:find("locker") and not isDepositContainer(container) then
				for _, item in pairs(container:getItems()) do
					local id = item:getId()
					if table.find(itemsToDeposit, id) then
						return true
					end
				end
			end
		end
	end

	local function hasDepositContainer()
		for _, container in pairs(g_game.getContainers()) do
			if isDepositContainer(container) then return true
			end
		end
	end
	
	CaveBot.registerAction("depositer", "red", function(value, retries)
		
		setAll()

    local wait = g_game.getPing() > 100 and (g_game.getPing()*3) or 300

		local val = string.split(value, ",")
		if #val ~= 2 then 
		  warn("CaveBot[Depositer]: Incorrect parameters, it should be house/depot, yes/no")
		  return true 
		else
		  dp = val[1]:trim():lower()
		  reopen = val[2]:trim():lower()
		end

		if not itemsToDeposit[1] then print(os.date('%H:%M ') .. player:getName() .." - CaveBot[Depositer]: items to deposit not configured") retries = 999999 return true end
		if oldversion and not depositContainers[1] then print(os.date('%H:%M ') .. player:getName() .." - CaveBot[Depositer]: containers to deposit not configured") retries = 999999 return true end

		-- checar retries
		if retries > 400 then 
			print(os.date('%H:%M ') .. player:getName() .." - CaveBot[Depositer]: Depositer actions limit reached, proceeding")
			resetCache(reopen)
			return true 
		end

		-- reaching and opening depot 
		if dp == "depot" and not CaveBot.ReachAndOpenDepot() then
			delay(wait)
			return "retry"
		end

		-- ver se tem alguma ação em execução...
		if time > now then return "retry" end

		-- ver se tem loot para depositar
		if reopen == "yes" and not closedLootContainers then
			closeLootContainers()
			delay(wait)
			closedLootContainers = true
			return "retry"
		elseif not hasDepositItems() then 
			if reopen == "yes" then
				for c, container in pairs(g_game:getContainers()) do
					local cId = container:getContainerItem():getId()
					if table.find(lootContainers,cId) or not reopenedLootContainers then
						for i, item in pairs(container:getItems()) do
							if table.find(lootContainers,item:getId()) then
								if not reopenedLootContainers then
									firstLoot = item
									g_game.open(item)
								else
									g_game.open(item,container)
								end
								reopenedLootContainers = true
								delay(wait)
								return "retry"
							end
						end
					end
				end
			end
			print(os.date('%H:%M ') .. player:getName() .." - CaveBot[Depositer]: No items to deposit")
			resetCache(reopen)
			return true 
		end

    if oldVersion or dp == "house" then
      -- abrir primeira bp para depositar
      if not hasDepositContainer() then
        if dp == "depot" then
          for c, container in pairs(g_game:getContainers()) do
            if container:getName():lower():find(dp) then
              for i, item in pairs(container:getItems()) do
                if table.find(depositContainers,item:getId()) then
                  g_game.open(item)
                  delay(wait)
                  return "retry"
                end
              end
            end
          end
        else
          for x = -3, 3 do
            for y = -3, 3 do
              local tile = g_map.getTile({x = posx() + x, y = posy() + y, z = posz()})
              if tile then
              local things = tile:getThings()
                for _, item in pairs(things) do
                  if table.find(depositContainers,item:getId()) then
                    g_game.open(item)
                    delay(wait)
                    return "retry"
                  end
                end
              end
            end
          end
        end
      end		

      -- ver um slot para depositar ou abrir a próxima bp
      if not destination then
        for _, container in pairs(g_game.getContainers()) do
          if isDepositContainer(container) then
            if haveSpace(container) then 
              destination = container
              return "retry"
            else
              for _, item in pairs(container:getItems()) do
                local id = item:getId()
                if table.find(depositContainers, id) then
                  g_game.open(item, container)
                  delay(wait)
                  return "retry"
                end
              end
            end
          end
        end
        print(os.date('%H:%M ') .. player:getName() .." - CaveBot[Depositer]: No more containers or space to deposit")
        resetCache(reopen)
        return true
      end

      -- ver se ainda tem espaço para depositar
      if not haveSpace(destination) then destination = nil return "retry" end

      -- DEPOSIT ITEM
      for c, container in pairs(g_game:getContainers()) do
        if not isDepositContainer(container) then
          for i, item in pairs(container:getItems()) do
            if isDepositItem(item) then
              g_game.move(item, destination:getSlotPosition(destination:getCapacity()), item:getCount())
              print(os.date('%H:%M ') .. player:getName() .." - CaveBot[Depositer]: Deposit Item: " .. item:getId())
              delay(wait)
              return "retry"
            end
          end
        end
      end

    else
      --versão nova
      destination = destination or getContainerByName("Depot chest")
      if not destination then return "retry" end

      for _, container in pairs(getContainers()) do
        local name = container:getName():lower()
        if not name:find("depot") and not name:find("your inbox") then
          for _, item in pairs(container:getItems()) do
            local id = item:getId()
            if isDepositItem(item) then
              local index = item:isStackable() and 1 or 0
              statusMessage("CaveBot[Depositer]: stashing item: " ..id.. " to depot: "..index+1)
              CaveBot.StashItem(item, index, destination)
              return "retry"
            end
          end
        end
      end
    end

		print(os.date('%H:%M ') .. player:getName() .." - CaveBot[Depositer]: Finished all actions.")
		resetCache(reopen)
		return true
	end)

	CaveBot.Editor.registerAction("depositer", "depositer", {
		value="depot, no",
		title="depositer",
		description=description,
		validation="(depot|Depot|DEPOT|house|House|HOUSE), (yes|Yes|YES|no|No|NO)"
		}
	)
end

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL