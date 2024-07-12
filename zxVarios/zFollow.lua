storage.followLeader = storage.followLeader or "Quentin"

FollowMacro = macro(1231321321, "Follow", function() end)

addTextEdit("playerToFollow", storage.followLeader, function(widget, text)
  storage.followLeader = text
end)


onCreaturePositionChange(function(creature, newPos, oldPos)
  if FollowMacro:isOff() then return end

  if newPos and oldPos and creature:getName() == player:getName() and getCreatureByName(storage.followLeader) == nil and newPos.z > oldPos.z then
    say('exani tera')
    for i = -1, 1 do
      for j = -1, 1 do
        local useTile = g_map.getTile({ x = posx() + i, y = posy() + j, z = posz() })
        g_game.use(useTile:getTopUseThing())
      end
    end
  end
  if creature:getName() == storage.followLeader then
    if not newPos then
      if oldPos then
        lastPos = oldPos

        schedule(200, function()
          autoWalk(oldPos)
        end)
      end

      schedule(1000, function()
        for i = -1, 1 do
          for j = -1, 1 do
            local useTile = g_map.getTile({ x = posx() + i, y = posy() + j, z = posz() })
            if useTile then
              local top useTile:getTopUseThing()
              if top then
                g_game.use(top)
              end
            end
          end
        end
      end)
    end

    if not newPos or not oldPos then return end
    if oldPos.z == newPos.z then
      schedule(300, function()
        local useTile = g_map.getTile({ x = oldPos.x, y = oldPos.y, z = oldPos.z })
        topThing = useTile:getTopThing()

        if not useTile:isWalkable() then
          use(topThing)
        end
      end)


      autoWalk({ x = oldPos.x, y = oldPos.y, z = oldPos.z })
    else
      lastPos = oldPos
      autoWalk(oldPos)
      for i = 1, 6 do
        schedule(i * 200, function()
          autoWalk(oldPos)

          if getDistanceBetween(pos(), oldPos) == 0 and (posz() > newPos.z and getCreatureByName(storage.followLeader) == nil) then
            say('exani tera')
          end
        end)
      end
      local useTile = g_map.getTile({ x = newPos.x, y = newPos.y - 1, z = oldPos.z })
      g_game.use(useTile:getTopUseThing())
    end
  end
end)