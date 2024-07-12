-- SE VOCE NÃO SABE O 'MODE' DA MENSAGEM DE TASK, USE O SCRIPT ABAIXO, MATE 1 MOB DA TASK E VEJA O QUE APARECE, USE ESTE MODE QUE APARECEU NA CONFIG DA MACRO.
---- PARA DESCOBRIR O MODE:
local teste = macro(1000000,"teste",function() end)

onTextMessage(function(mode, text)
  if not teste:isOn() then return end
  if not text:find("Pos-Finalizada") then return end
  talkPrivate(player:getName(),text.." mode: "..mode)
end)
-- DEPOIS DE DESCOBRIR O MODE PODE REMOVER ESSA PARTE DE CIMA DO CÓDIGO


-- MACRO PARA SAIR DA HUNT SE TERMINAR A TASK
-- START CONFIG
local taskMessage = {
  mode = 17,
  text = "finalizada.",
}
-- END CONFIG

local taskMacro = macro(12312313,"Tasker",function()end)
onTextMessage(function(mode, text)
  if not taskMacro:isOn() then return end
  if mode ~= taskMessage.mode then return end
  if not text:find(taskMessage.text) then return end
  storage.taskFinalizada = true
end)


-- AGORA UMA FUNÇÃO NO CAVEBOT, INCLUIR COMO 'FUNCTION' NO CAVEBOT, NA PARTE DA HUNT QUE VC QUER VERIFICAR SE TERMINOU A TASK OU NAO
-- ESSAS 2 LABELS CONFIGURADAS ABAIXO PRECISAM ESTAR CRIADAS NO CAVEBOT, COM NOMES EXATOS
-- FUNÇÃO:

-- START CONFIG
local labels = {
  taskFinalizada = 'SairDaHunt',
  taskNaoFinalizada = "ContinuarHunt",
}
-- END CONFIG

if storage.taskFinalizada then
  CaveBot.gotoLabel(labels.taskFinalizada)
else
  CaveBot.gotoLabel(labels.taskNaoFinalizada)
end
return true


-- E DEPOIS QUE PEGAR OUTRA TASK, ANTES DE VOLTAR PRA HUNT, COLOCAR ESSA FUNÇÃO NO CAVEBOT:
storage.taskFinalizada = false