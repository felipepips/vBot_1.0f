setDefaultTab("Main")
UI.Separator()

-- START CONFIG:
local oldVersions = false -- true: servers that doesnt allow using items with hotkeys (items must be visible)
local panels = { -- HOW MANY PANELS FOR EACH TYPE OF HEALING DO YOU WANT?
  ['Healing Items'] = {
    ['MP'] = 1,
    ['HP'] = 0,
  },
  ['Healing Spells'] = {
    ['MP'] = 0,
    ['HP'] = 0,
  },
}
local checkInterval = 250 -- milliseconds

-- END OF CONFIG, DO NOT EDIT ANYTHING BELOW, UNLESS YOU KNOW WHAT YOU ARE DOING

local stName = "OldHeal"
storage[stName] = storage[stName] or {}
local config = storage[stName]

local function getPercent(HPorMP)
  if HPorMP == "MP" then
    return manapercent() or math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
  else
    return hppercent() or player:getHealthPercent()
  end
end

for healType, entries in pairs(panels) do
  local healTypeLabel
  config[healType] = config[healType] or {}
  for HPorMP, amount in pairs(entries) do
    if amount > 0 then
      for i = 1, amount do
        -- create label for heal type
        if not healTypeLabel then
          healTypeLabel = true
          UI.Label(healType)
        end
        -- create base storages if doesnt exists
        config[healType][HPorMP] = config[healType][HPorMP] or {}
        if not config[healType][HPorMP][i] or type(config[healType][HPorMP][i]) ~= 'table' then
          config[healType][HPorMP][i] = {on=false, title=HPorMP.."%", min=51, max=90}
          if healType == 'Healing Items' then
            config[healType][HPorMP][i].item = 3160
          else
            config[healType][HPorMP][i].text = 'exura vita'
          end
        end
        local healConfig = config[healType][HPorMP][i]
        -- macros
        local healingMacro = macro(checkInterval,function()
          local current = getPercent(HPorMP)
          if healConfig.min <= current and current < healConfig.max then
            if healType == 'Healing Items' then
              -- use item
              local thing = g_things.getThingType(healConfig.item)
              local subType = g_game.getClientVersion() >= 860 and 0 or 1
              if thing and thing:isFluidContainer() then
                subType = healConfig.subType
              end
              if oldVersions then
                -- find item to use
                local find = g_game.findPlayerItem(healConfig.item, subType)
                if find then
                  g_game.useWith(find, player)
                end
              else
                g_game.useInventoryItemWith(healConfig.item, player, subType)
              end
            else
              -- use spell
              if TargetBot then 
                -- sync spell with targetbot if available
                TargetBot.saySpell(healConfig.text)
              else
                say(healConfig.text)
              end
            end
          end
        end)
        healingMacro.setOn(healConfig.on)
        -- panels
        if healType == 'Healing Items' then
          UI.DualScrollItemPanel(healConfig, function(widget, newParams) 
            healConfig = newParams
            healingMacro.setOn(healConfig.on and healConfig.item > 100)
          end)
        else
          UI.DualScrollPanel(healConfig, function(widget, newParams) 
            healConfig = newParams
            healingMacro.setOn(healConfig.on)
          end)
        end
      end
      UI.Separator()
    end
  end
end