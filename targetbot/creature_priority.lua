TargetBot.Creature.calculatePriority = function(creature, config, path)
  -- config is based on creature_editor
  local priority = 0
  local currentTarget = g_game.getAttackingCreature()

  -- extra priority if it's current target
  if currentTarget == creature then
    priority = priority + 1
  end

  -- check if distance is ok
  if #path > config.maxDistance then
    if config.rpSafe then
      if currentTarget == creature then
        g_game.cancelAttackAndFollow()  -- if not, stop attack (pvp safe)
      end
    end
    return priority
  end

  -- add config priority
  priority = priority + config.priority
  
  -- extra priority for close distance
  local path_length = #path
  local max_increase_by_distance = 10
  local max_distance = 5
  if isTrapped() and path_length == 1 then
    priority = priority + (2 * max_increase_by_distance) -- double extra priority if trapped
  elseif path_length <= max_distance then
    local calc = (max_distance - path_length + 1) / max_distance * max_increase_by_distance
    priority = priority + calc
  end

  -- extra priority for paladin diamond arrows
  if config.diamondArrows then
    local mobCount = getCreaturesInArea(creature:getPosition(), diamondArrowArea, 2)
    priority = priority + (mobCount * 4)

    if config.rpSafe then
      if getCreaturesInArea(creature:getPosition(), largeRuneArea, 3) > 0 then
        if currentTarget == creature then
          g_game.cancelAttackAndFollow()
        end
        return 0 -- pvp safe
      end
    end
  end

  -- extra priority for low health
  local max_increase_by_health = 10
  local hp = creature:getHealthPercent()
  if config.chase and hp < 30 then
    priority = priority + max_increase_by_health
  else
    local calc = (100 - hp) / 100 * max_increase_by_health
    priority = priority + calc
  end

  return priority
end