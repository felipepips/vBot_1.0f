-- COMO FUNCIONA:
-- CONFIGURAR AQUI O ID DO BÁU E O ID DAS BAGS QUE FICAM DENTRO
local chest_id = 2871
local bag_id = 2854
local move_delay = 500

-- DEPOIS DE TERMINAR O BOSS, COLOCAR 1 USE NO CAVEBOT, PARA O CAVEBOT ABRIR O CHEST
-- DEPOIS QUE O CHEST FOR ABERTO, A MACRO VAI VERIFICAR AS BAGS QUE TEM DENTRO
-- OS ITENS QUE VC QUER QUE PEGUE DE DENTRO DAS BAGS, TEM QUE CONFIGURAR NO TARGETBOT, NA LISTA DE LOOT NORMAL
-- O QUE NÃO TIVER NA LISTA DE LOOT DO TARGETBOT, A MACRO VAI DEIXAR LÁ.
-- A MACRO SÓ VAI ABRIR 1X CADA BAG
-- SE REINICIAR O CLIENT, NA PROXIMA VEZ Q ABRIR O CHEST, VAI VERIFICAR TODAS NOVAMENTE

-- FIM DA CONFIGURAÇÃO


local paused = false
macro(move_delay,"Boss Loot",function()
  -- primeiro vê se tem bag aberta para tirar os itens de dentro
  local bag = getContainerByItem(bag_id)
  if bag then
    if CaveBot.isOn() then
      CaveBot.setOff()
      paused = true
    end
    for i, item in ipairs(bag:getItems()) do
      local loot = CaveBot.GetLootItems()
      if table.find(loot,item:getId()) then
        -- ver para onde vai mover
        for c, cont in pairs(g_game.getContainers()) do
          if not table.find({bag_id,chest_id},cont:getContainerItem():getId()) then
            if not containerIsFull(cont) then
              -- movendo
              return g_game.move(item,cont:getSlotPosition(cont:getCapacity()),item:getCount())
            end
          end
        end
      end
    end
    -- mais nada para retirar.. fecha a bag
    return g_game.close(bag)
  end
  -- agora vamos ver se tem mais alguma bag pra abrir
  local chest = getContainerByItem(chest_id)
  if chest then
    if CaveBot.isOn() then
      CaveBot.setOff()
      paused = true
    end
    for i, item in ipairs(chest:getItems()) do
      if not item.aberto and item:getId() == bag_id then
        item.aberto = true
        return g_game.open(item,nil)
      end
    end
    -- nenhuma bag mais para abrir, vamos ver se tem proxima pagina
    if chest.window and chest:hasPages() then
      local nextPageButton = chest.window:recursiveGetChildById('nextPageButton')
      if nextPageButton and nextPageButton:isEnabled() then
        return nextPageButton.onClick()
      end
    end
  end
  if paused then
    CaveBot.setOn()
    paused = false
  end
end)