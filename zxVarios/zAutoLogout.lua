
-- AUTO LOG-OUT IF MSG RECEIVED
local msgToFind = "has logged in"
local friendList = {"nombre maker 1","nombre maker 2"} -- solo vas a salir si estos players te envian mensaje

-- END CONFIG

-- esto es para cuando se conecte otra vez, despues de loggear, que se prenda el autoreconnect otra vez
g_settings.set('autoReconnect', true)

local salir = false

local almacro = macro(2000,"Auto LogOut",function()
  if not salir then return end
  CaveBot.setOff()
  g_settings.set('autoReconnect', false)
  modules.game_interface.tryLogout(false)
end)

onTalk(function(name, level, mode, text, channelId, pos)
  if not almacro:isOn() then salir = false return end
  if not table.find(friendList,name,true) then return end
  if not text:find(msgToFind) then return end
  talkPrivate(player:getName(),text.." apagando cavebot para loggear")
  salir = true
end)