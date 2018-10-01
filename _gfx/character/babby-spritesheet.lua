--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:665dc99fb02cad9e79c011ae9c0e4d72:274489d54913a087414c0b8bda987e4c:d82eaaeebba91585ef38411bb16c29cf$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- babby-fly-01
            x=0,
            y=0,
            width=105,
            height=127,

        },
        {
            -- babby-fly-02
            x=105,
            y=0,
            width=105,
            height=127,

        },
        {
            -- babby-fly-03
            x=0,
            y=127,
            width=105,
            height=127,

        },
        {
            -- babby-fly-04
            x=105,
            y=127,
            width=105,
            height=127,

        },
        {
            -- babby-fly-05
            x=0,
            y=254,
            width=105,
            height=127,

        },
        {
            -- babby-fly-06
            x=105,
            y=254,
            width=105,
            height=127,

        },
        {
            -- babby-ground-pound-01
            x=0,
            y=381,
            width=93,
            height=91,

        },
        {
            -- babby-ground-pound-02
            x=93,
            y=381,
            width=93,
            height=91,

        },
        {
            -- babby-idle-01
            x=0,
            y=472,
            width=88,
            height=82,

        },
        {
            -- babby-idle-02
            x=88,
            y=472,
            width=88,
            height=82,

        },
        {
            -- babby-idle-03
            x=0,
            y=554,
            width=88,
            height=82,

        },
        {
            -- babby-idle-04
            x=88,
            y=554,
            width=88,
            height=82,

        },
        {
            -- babby-idle-05
            x=0,
            y=636,
            width=88,
            height=82,

        },
        {
            -- babby-idle-06
            x=88,
            y=636,
            width=88,
            height=82,

        },
        {
            -- babby-tweet-attack-01
            x=0,
            y=718,
            width=116,
            height=89,

        },
        {
            -- babby-tweet-attack-02
            x=116,
            y=718,
            width=116,
            height=89,

        },
        {
            -- babby-walk-01
            x=0,
            y=807,
            width=105,
            height=99,

        },
        {
            -- babby-walk-02
            x=105,
            y=807,
            width=105,
            height=99,

        },
        {
            -- babby-walk-03
            x=0,
            y=906,
            width=105,
            height=99,

        },
        {
            -- babby-walk-04
            x=105,
            y=906,
            width=105,
            height=99,

        },
        {
            -- babby-walk-05
            x=0,
            y=1005,
            width=105,
            height=99,

        },
        {
            -- babby-walk-06
            x=105,
            y=1005,
            width=105,
            height=99,

        },
    },

    sheetContentWidth = 232,
    sheetContentHeight = 1104
}

SheetInfo.frameIndex =
{

    ["babby-fly-01"] = 1,
    ["babby-fly-02"] = 2,
    ["babby-fly-03"] = 3,
    ["babby-fly-04"] = 4,
    ["babby-fly-05"] = 5,
    ["babby-fly-06"] = 6,
    ["babby-ground-pound-01"] = 7,
    ["babby-ground-pound-02"] = 8,
    ["babby-idle-01"] = 9,
    ["babby-idle-02"] = 10,
    ["babby-idle-03"] = 11,
    ["babby-idle-04"] = 12,
    ["babby-idle-05"] = 13,
    ["babby-idle-06"] = 14,
    ["babby-tweet-attack-01"] = 15,
    ["babby-tweet-attack-02"] = 16,
    ["babby-walk-01"] = 17,
    ["babby-walk-02"] = 18,
    ["babby-walk-03"] = 19,
    ["babby-walk-04"] = 20,
    ["babby-walk-05"] = 21,
    ["babby-walk-06"] = 22,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
