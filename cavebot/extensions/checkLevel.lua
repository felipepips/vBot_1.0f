CaveBot.Extensions.LvlCheck = {}

CaveBot.Extensions.LvlCheck.setup = function()
  CaveBot.registerAction("LvlCheck", "#00FFFF", function(value, retries)
    local data = string.split(value, ",")
    if #data ~= 3 then
     warn("wrong format, should be: level, leaveHunt, startHunt")
     return false
    end
    local minRange, maxRange
    local leaveLabel = data[2]:trim()
    local loopLabel = data[3]:trim()
    local lvlRange = string.split(data[1], ":")
    local level = lvl()

    minRange = tonumber(lvlRange[1])
    maxRange = (#lvlRange > 1 and tonumber(lvlRange[2]) or nil)

    if minRange and maxRange then
      if level >= minRange and level <= maxRange then
        CaveBot.gotoLabel(leaveLabel)
        print("CaveBot[LvlCheck]: level range ".. "(".. minRange.. "-"..maxRange .." reached, proceeding to label "..leaveLabel)
        return true
      end
    elseif minRange then
      if level >= minRange then
        print("CaveBot[LvlCheck]: level ".. minRange.." reached, proceeding to label "..leaveLabel)
        CaveBot.gotoLabel(leaveLabel)
        return true
      end
    end

    print("CaveBot[LvlCheck]: level not reached, proceeding to label "..loopLabel)
    CaveBot.gotoLabel(loopLabel)
    return true
  end)

  CaveBot.Editor.registerAction("lvlcheck", "lvl check", {
    value=function() return lvl() .. ", leaveHunt, startHunt" end,
    title="Level Check",
    description="level or range (10:100), label to leave, label to loop",
    multiline=false,
})
end