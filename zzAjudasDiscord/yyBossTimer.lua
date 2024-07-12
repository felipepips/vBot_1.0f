-- CaveBot Function

-- START CONFIG
local intervalo = (2 * 60 * 60) -- (em segundos) 2h x 60min x 60s
local nome_da_label = "goBoss" -- ir para essa label se já passou o intervalo
-- END CONFIG

storage.lastBoss = storage.lastBoss or os.time()
if os.time() - storage.lastBoss >= intervalo then
  gotoLabel(nome_da_label)
  storage.lastBoss = os.time()
end
return true