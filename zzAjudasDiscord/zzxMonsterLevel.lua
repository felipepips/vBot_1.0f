local list = {
  [1] = {name="rat",exp=5,life=20},
  [2] = {name="minotaur",exp=50,life=100},
  [3] = {name="cyclops",exp=150,life=260},
  [4] = {name="dragon",exp=700,life=1000},
  [5] = {name="dragon lord",exp=2100,life=1900},
  [6] = {name="serpent spawn",exp=3050,life=3000},
  [7] = {name="demon",exp=6000,life=8200},
  [8] = {name="juggernaut",exp=14000,life=20000},
}

singlehotkey("f2","monsterLvl",function()
  print("-------start-------")

  for e, entry in ipairs(list) do
    print(entry.name)
    local val = entry.exp + entry.life
    print("old")
    a(val)
    print("new")
    b(val)
    print("----------------")
  end



  print("-------end-------")
end)

function a(monsterValue)
  local level = 1
  if monsterValue / 100 >= 1000 then level = math.ceil(math.log(monsterValue) * 10)
  elseif monsterValue / 100 >= 100 then level = math.ceil(math.log(monsterValue / 2) * 10)
  elseif monsterValue / 100 >= 10 then level = math.ceil(math.log(monsterValue / 4) * 8)
  elseif monsterValue / 100 >= 5 then level = math.ceil(math.log(monsterValue / 6) * 6)
  elseif monsterValue / 100 >= 1 then level = math.ceil(math.log(monsterValue / 8) * 4)
  else level = math.ceil(math.log(monsterValue / 10) * 2)
  end
  print(math.max(1, level))
end

function b(monsterValue)
  level = math.ceil(math.pow(monsterValue, 0.478))
  print(math.max(1, level))
end