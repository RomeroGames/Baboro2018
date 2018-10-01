--[[-------------------------------------------------------------------------------------

End game credits

---------------------------------------------------------------------------------------]]
local C = {}

local creditFontSize = 48

local names =
{
    "By Romero Games and...",
    "",
    "Shauna Simpson",
    "Dara Simpson",
    "James Dunne",
    "Laurence Dunne",
    "Devan Bell",
    "Noah Rafferty",
    "Luke Meade",
    "Tom Murray",
    "Nathan Sullivan",
    "Darragh Coyne",
    "Rian Camaron Walsh",
    "John Morrison",
    "Alex Doyle",
    "Finn Cuilligan",
    "Caoilfhionn Fitzpatrick",
    "Bruce Fitzpatrick",
    "Samuel Aurnekeith",
    "Ciaran Allen",
    "Conor Lawlor",
    "Ethan Cunningham",
    "Ryan Gallen",
    "Noah Mun\'goma Webb",
    "Lily Lahdensuo",
    "Thomas Roache",
    "Logan Flaherty",
    "Harrison Finn",
    "Derek Flaherty",
    "Michael Brennan",
    "Aidan Brennan",
    "Robert McMahon",
    "Gregory McMahon",
    "Daniel Leahy-Coen",
    "Luca Walsh",
    "Daehan Coll",
    "Nara Coll",
    "Daniel Butler",
    "Ciara Gregan",
    "Shay Gregan",
    "Riain Ambrose",
    "Christopher Conneely",
    "Liam Pearce",
    "Conor Pearce",
    "Fionn Cannith",
    "Lucas O\'Conaola",
    "Liam O\'Conaola",
    "Noah Challenger",
}

function C.rollCredits()
    local creditString = ""
    for i=1,#names do
        creditString = creditString..names[i].."\n"
    end

    local credits = display.newText({ text = creditString, x = display.contentWidth / 2, y = display.contentHeight, fontSize = creditFontSize, font = "godofwar.ttf", align = "center" } )
    credits.anchorY = 0

    transition.moveTo(credits, {time = 30000, x = display.contentWidth / 2, y = -(#names * creditFontSize * 1.1)})
end

return C
