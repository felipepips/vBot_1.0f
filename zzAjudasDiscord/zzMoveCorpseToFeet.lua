-- on Almeida_v5.0\targetbot\looting.lua
-- search for

g_game.open(container)
waitTill = now + (storage.extras.lootDelay or 200)
waitingForContainer = container:getId()

--change to:

g_game.open(container)
g_game.move(container,player:getPosition(),1)
waitTill = now + (storage.extras.lootDelay or 200)
waitingForContainer = container:getId()