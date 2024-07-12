-- CONFIG:
local maxDistance = 5

-- STORAGE
storage.SimpleHealFriends = storage.SimpleHealFriends or {text = "", friends = {}}
local config = storage.SimpleHealFriends
config.heal = config.heal or {on=false, title="HP%", item=266, min=51, max=100}

-- PARSE FRIENDS TEXT TO TABLE
local function parseFriendList()
  local friends = config.text:split("\n")
  for _, text in pairs(friends) do
    local split = text:split(",")
    local name = split[1]
    local min = math.max(math.min(tonumber(split[2]),100),1)
    local max = math.max(math.min(tonumber(split[3]),100),1)
    config.friends[name] = {min=min,max=max}
  end
end

-- UI
UI.Label("Heal Friends")
UI.Label("Self HP:")
-- ITEM TO USE
local healFriendMacro = macro(150, function()
  -- check self hp
  local selfHp = player:getHealthPercent()
  if selfHp < config.heal.min then return end

  -- check friends
  local selfPos = pos()
  for name, hp in pairs(config.friends) do
    local friend = getCreatureByName(name)
    if friend then
      if friend:canShoot() and getDistanceBetween(selfPos,friend:getPosition()) <= maxDistance then
        local friendHp = friend:getHealthPercent()
        if hp.min <= friendHp and friendHp < hp.max then
          return g_game.useInventoryItemWith(config.heal.item, friend)
        end
      end
    end
  end
end)
healFriendMacro.setOn(config.heal.on)

UI.DualScrollItemPanel(config.heal, function(widget, newParams) 
  config.heal = newParams
  healFriendMacro.setOn(config.heal.on)
end)

-- FRIENDS LIST
UI.Button("Edit Friend List", function(newText)
  UI.MultilineEditorWindow(config.text or "", {title="Heal Friends List", description="Insert 1 friend in each line, this way:\nFriend Name, min HP, max HP"},
  function(text)
    config.text = text
    if #text > 3 then
      parseFriendList()
    else
      config.friends = {}
    end
  end)
end)