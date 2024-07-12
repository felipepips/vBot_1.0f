-- START CONFIG
local bomb_id = 3043
local wait = 50 -- milliseconds, tiempo de espera entre jugar el item y despues usarlo
local tries = 20 -- cuantas veces vas a intentar explotar la mina despues de arrojarla
-- END CONFIG

singlehotkey("F4","Bomb Target",function()
  if not g_game.isAttacking() then return end
  local c = g_game.getAttackingCreature()
  local cPos = c:getPosition()
  local item = findItem(bomb_id)
  if item then
    g_game.move(item,cPos)
    for i=1,tries do
      schedule(wait*i,function()
        local tile = g_map.getTile(cPos)
        if tile then
          local topItem = tile:getTopUseThing()
          if topItem then
            if topItem:getId() == bomb_id then
              g_game.use(topItem)
            end
          end
        end
      end)
    end
  end
end)