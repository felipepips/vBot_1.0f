if lvl() <= 8 then
  setDefaultTab("Main")
  local lab = UI.Label("[[ SELECT VOCATION ]]")
  lab:setColor("yellow")
  lab:setFont("verdana-11px-rounded")

local ui = setupUI([[
Panel
  height: 100

  Label
    text: Vocation Select

  ComboBox
    id: vocation
    anchors.top: prev.bottom
    width: 176
    options: [Knight, Paladin, Sorcerer, Druid]

  Label
    margin-top: 10
    text: Weapon Select (for Knights)
    anchors.top: prev.bottom

  ComboBox
    id: weapon
    anchors.top: prev.bottom
    width: 176
    options: [Axe, Sword, Club]
]])

  local weapons = {
    ["Axe"] = 7773,
    ["Sword"] = 7774,
    ["Club"] = 3327
  }

  local stN = "ChooseVoc"
  if not storage[stN] then 
    storage[stN] = {
      vocation = "Knight",
      weapon = "Sword",
      weaponId = 7774
    }
  end
  local config = storage[stN]

  ui.vocation:setText(config.vocation)
  ui.vocation.onOptionChange = function(widget)
    config.vocation = widget:getCurrentOption().text
  end

  ui.weapon:setText(config.weapon)
  ui.weapon.onOptionChange = function(widget)
    config.weapon = widget:getCurrentOption().text
    config.weaponId = weapons[config.weapon]
  end
end