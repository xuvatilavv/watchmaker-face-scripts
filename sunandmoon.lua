--[[ shadowrot travels between 90 and 270
moon and sun x and y travel in circle around edge
both according to weather's sunrise and sunset times ]]--
dayDuration = 0.5
nightDuration = 0.5

sunriseDegrees = 0.25*180
sunsetDegrees = 0.75*180
midnightDegrees = 1.0*180

morningAngle = 0
daytimeAngle = 90
eveningAngle = 180

var_sunx = 100
var_suny = 100
var_moonx = -100
var_moony = -100
var_sunopac = 100
var_moonopac = 0
var_shadowangle = 180

is_bright = 1 -- this is a built-in variable, but initialize to prevent inconsistent initial behavior


function doNothing(freq)
return 1
end


--{dm}
function GetShadowAngle(freq)
if is_bright then
var_shadowangle = 180
if {dtp} > {wssp} then -- sunset to midnight
eveningAngle = ({drh24}/2 - sunsetDegrees) / nightDuration
var_shadowangle = 90 + eveningAngle
elseif {dtp} >= {wsrp} then -- sunrise to sunset
daytimeAngle = ({drh24}/2 - sunriseDegrees) / dayDuration
var_shadowangle = 90 + daytimeAngle
else -- midnight to sunrise
morningAngle = ({drh24}/2 + midnightDegrees) / nightDuration
var_shadowangle = 90 + morningAngle
end
end
return 1
end


-- call with {dm} from empty element to update every minute
function CalcDayNight(freq)
dayDuration = {wssp} - {wsrp}
nightDuration = 1 - {wssp} + {wsrp}

sunriseDegrees = {wsrp} * 180
sunsetDegrees = {wssp} * 180
midnightDegrees = (1 - {wssp}) * 180

sunriseRadians = math.rad(sunriseDegrees)
sunsetRadians = math.rad(sunsetDegrees)
midnightRadians = math.rad(midnightDegrees)

return 1
end


-- call with {dm} to update every minute
function CelestialLocations(freq)
--if is_bright then
if {dtp} > {wssp} then -- sunset to midnight
var_sunx = math.sin(math.rad(eveningAngle)+math.pi/2) * 250
var_suny = math.cos(math.rad(eveningAngle)+math.pi/2) * -250
elseif {dtp} > {wsrp} then -- sunrise to sunset
var_sunx = math.sin(math.rad(daytimeAngle)-math.pi/2) * 250
var_suny = math.cos(math.rad(daytimeAngle)-math.pi/2) * -250
else -- midnight to sunrise
var_sunx = math.sin(math.rad(morningAngle)+math.pi/2) * 250
var_suny = math.cos(math.rad(morningAngle)+math.pi/2) * -250
end
var_moonx = math.floor(-var_sunx * 0.9)
var_moony = math.floor(-var_suny * 0.9)
--end
return 1
end


-- call with {dm}
function CelestialOpacity(freq)
if {dtp} > {wssp} + 0.015 then -- sunset to midnight
var_sunopac = 0
elseif {dtp} > {wssp} - 0.015 then -- sunset transition
progress = {dtp} - ({wssp} - 0.015)
var_sunopac = 100 - ((progress / .03) * 100)
elseif {dtp} > {wsrp} + 0.015 then -- sunrise to sunset
var_sunopac = 100
elseif {dtp} > {wsrp} - 0.015 then -- sunrise transition
progress = {dtp} - ({wsrp} - 0.015)
var_sunopac = ((progress / .03) * 100)
else -- midnight to sunrise
var_sunopac = 0
end
var_moonopac = 100 - var_sunopac
return 1
end


function initialize()
CalcDayNight(0)
CelestialLocations(0)
CelestialOpacity(0)
GetShadowAngle(0)
end


initialize()
