-- CaveBot Function

-- START CONFIG
local min_stamina = (16 * 60) -- (em minutos) 16h x 60min
local nome_da_label = "deslogar" -- ir para essa label se tiver pouca stamina
-- END CONFIG

if stamina() < min_stamina then gotoLabel(nome_da_label) end
return true