-- CHECK REFILL
local label_continuar = "continuar"
local label_refill = "refilar"
local items = {
  --[ID] = {min = QUANTIDADE},
  [3160] = {min = 100},
  [19470] = {min = 100},
}

for e, entry in pairs(items) do
  if itemAmount(e) < entry.min then
    gotoLabel(label_refill)
    return true
  end
end
gotoLabel(label_continuar)
return true