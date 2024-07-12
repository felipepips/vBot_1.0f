-- --Description: A macro to follow players through stairs, doors, ladders, sewer gates and some other things. 
-- --A message error appears on the log, but other than that everything seems to run well... save for the eventual hiccups!
-- --ATTENTION: It might not work if multiple "use objects" that lead to different places are near eachother.

-- Follow = macro(1000,"Follow",function()

--   nome = storage.followLeader
--   end)
  
--   UI.Label("Follow Player:")
--   addTextEdit("playerToFollow", storage.followLeader or "Heeey", function(widget, text)
--       storage.followLeader = text
--       target = tostring(text)
--   end)
  
--   nome = storage.followLeader
--   pos_p = player:getPosition()
  
--   p = getCreatureByName(nome)
  
--   onCreaturePositionChange(function(creature, newPos, oldPos)
--       if Follow.isOn() then
      
--           if creature:getName()==player:getName() and getCreatureByName(nome) == nil and newPos.z>oldPos.z then
          
--               say('exani tera')
--               for i = -1,1 do
--                 for j = -1,1 do
              
--                   local useTile = g_map.getTile({x=posx()+i,y=posy()+j,z=posz()})
--                    g_game.use(useTile:getTopUseThing())
                  
              
--                 end
--               end
--           end
--           if creature:getName()==nome then
            
              
--               if newPos==nil then
                  
                  
--                   lastPos = oldPos
                  
--                   schedule(200,function()
--                    autoWalk(oldPos)
--                   end)
                  
--                   schedule(1000,function()
--                       for i = -1,1 do
--                         for j = -1,1 do
                      
--                           local useTile = g_map.getTile({x=posx()+i,y=posy()+j,z=posz()})
--                           g_game.use(useTile:getTopUseThing())
                          
                      
--                         end
--                       end
--                   end)
              
              
--               end
              
--               if oldPos.z == newPos.z then
                       
--                   schedule(300,function()
--                    local useTile = g_map.getTile({x=oldPos.x,y=oldPos.y,z=oldPos.z})
--                    topThing = useTile:getTopThing()
                   
--                    if not useTile:isWalkable() then
--                      use(topThing)
--                    end
                  
--                   end)
              
              
--                   autoWalk({x=oldPos.x,y=oldPos.y,z=oldPos.z})
--               else
              
--                   lastPos = oldPos
--                   autoWalk(oldPos)
--                   for i = 1,6 do
--                       schedule(i*200,function()
--                         autoWalk(oldPos)
                      
--                         if getDistanceBetween(pos(), oldPos) == 0 and (posz()>newPos.z and getCreatureByName(nome) == nil) then
--                           say('exani tera')
--                         end
--                       end)
--                   end
--                   local useTile = g_map.getTile({x=newPos.x,y=newPos.y-1,z=oldPos.z})
--                    g_game.use(useTile:getTopUseThing())
                              
              
--               end
            
          
--           end
      
--       end
--   end)