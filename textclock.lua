-- textclock 12/24
var_mode = 12

var_line1 = {text = "hi", is_visible = 0, pos = 1}
var_line2 = {text = "yo", is_visible = 0, pos = 2}
var_line3 = {text = "oi", is_visible = 0, pos = 3}
var_line4 = {text = "xo", is_visible = 0, pos = 4}

var_line1_y = 0
var_line2_y = 0
var_line3_y = 0
var_line4_y = 0

lineDifference = 86
centerOffset = 0

coordsTwo = {centerOffset - (lineDifference*0.5), centerOffset + (lineDifference*0.5)}
coordsThree = {centerOffset - lineDifference, centerOffset, centerOffset + lineDifference}
coordsFour = {centerOffset - (lineDifference*1.5), centerOffset - (lineDifference*0.5),
centerOffset + (lineDifference*0.5), centerOffset + (lineDifference*1.5)}

var_test = "wizard"
var_test2 = "bonkers"
var_test3 = "wham"


function DoNothing(freq)
return true
end


-- separate tens and ones for 24 hour formatting
function GetHourTens(freq)
if var_mode == 24 then

if {dh23} < 10 then var_line1.text = "zero"
elseif {dh23} > 19 then var_line1.text = "twenty"
else var_line1.text = " "
end

else -- 12 hour
var_line1.text = " "
end
return true
end


function GetHourOnes(freq)
if var_mode == 24 then

if {dh23} > 9 and {dh23} < 20 then var_line2.text = {dh24t}
else
if {dh23to} == "0" then var_line2.text = " "
elseif {dh23to} == "1" then var_line2.text = "one"
elseif {dh23to} == "2" then var_line2.text = "two"
elseif {dh23to} == "3" then var_line2.text = "three"
elseif {dh23to} == "4" then var_line2.text = "four"
elseif {dh23to} == "5" then var_line2.text = "five"
elseif {dh23to} == "6" then var_line2.text = "six"
elseif {dh23to} == "7" then var_line2.text = "seven"
elseif {dh23to} == "8" then var_line2.text = "eight"
elseif {dh23to} == "9" then var_line2.text = "nine"
end
end

else -- 12 hour
var_line2.text = {dht}
end
return true
end


function GetMinuteTens(freq)
if var_mode == 12 then

if {dm} == 0 then var_line3.text = "o'clock"
elseif {dmt} == "0" then var_line3.text = "oh"
else var_line3.text = {dmtt}
end

else -- 24 hour
if {dm} == 0 or {dmt} == "0" then var_line3.text = "hundred"
else var_line3.text = {dmtt}
end

end
return true
end


function GetMinuteOnes(freq)
if var_mode == 12 then

if {dmo} == "0" or ({dm} > 10 and {dm} < 20) then var_line4.text = " "
else var_line4.text = {dmot}
end

else -- 24 hour
if {dm} % 10 == 0 or ({dm} > 10 and {dm} < 20) then var_line4.text = " "
else var_line4.text = {dmot}
end

end
return true
end


-- return visible line count and update visiblity variables
function GetVisibleLines()
visibleLines = {}
visibleCount = 0

if var_line1.text ~= " " then
var_line1.is_visible = 1
var_line1.pos = visibleCount + 1
visibleCount = visibleCount + 1
else
var_line1.is_visible = 0
var_line1.pos = nil
end

if var_line2.text ~= " " then
var_line2.is_visible = 1
var_line2.pos = visibleCount + 1
visibleCount = visibleCount + 1
else
var_line2.is_visible = 0
var_line2.pos = nil
end

var_line3.is_visible = 1
var_line3.pos = visibleCount + 1
visibleCount = visibleCount + 1

if var_line4.text ~= " " then
var_line4.is_visible = 1
var_line4.pos = visibleCount + 1
visibleCount = visibleCount + 1
else
var_line4.is_visible = 0
var_line4.pos = nil
end

return visibleCount
end


function GetMyCoordY(freq, line)
coords = {}
visibleCount = GetVisibleLines()

if visibleCount == 2 then
coords = coordsTwo
elseif visibleCount == 3 then
coords = coordsThree
elseif visibleCount == 4 then
coords = coordsFour
else
coords = nil
end

if line == 1 then
var_line1_y = coords[var_line1.pos]
elseif line == 2 then
var_line2_y = coords[var_line2.pos]
elseif line == 3 then
var_line3_y = coords[var_line3.pos]
elseif line == 4 then
var_line4_y = coords[var_line4.pos]
end

return true
end

var_latest = 2
function showLatest(data)
var_latest = data
return true
end


function RunEveryMinute(freq)
GetHourTens(0)
GetHourOnes(0)
GetMinuteTens(0)
GetMinuteOnes(0)
GetMyCoordY(0, 1)
GetMyCoordY(0, 2)
GetMyCoordY(0, 3)
GetMyCoordY(0, 4)
return true
end


RunEveryMinute(0)
