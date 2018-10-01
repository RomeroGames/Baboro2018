--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:47cac52c2c646901dbcf86d7af501a8b:df851bcbc7ecf18bcf4c16a8adb105a1:0615d3dd4f41ba075240e9a704073f61$
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
            -- tweet-attack-01
            x=0,
            y=0,
            width=195,
            height=277,

        },
        {
            -- tweet-attack-02
            x=0,
            y=277,
            width=195,
            height=277,

        },
        {
            -- tweet-attack-03
            x=0,
            y=554,
            width=195,
            height=277,

        },
        {
            -- tweet-attack-04
            x=0,
            y=831,
            width=195,
            height=277,

        },
        {
            -- tweet-attack-05
            x=0,
            y=1108,
            width=195,
            height=277,

        },
        {
            -- tweet-attack-06
            x=0,
            y=1385,
            width=195,
            height=277,

        },
        {
            -- tweet-attack-07
            x=0,
            y=1662,
            width=195,
            height=277,

        },
    },

    sheetContentWidth = 195,
    sheetContentHeight = 1939
}

SheetInfo.frameIndex =
{

    ["tweet-attack-01"] = 1,
    ["tweet-attack-02"] = 2,
    ["tweet-attack-03"] = 3,
    ["tweet-attack-04"] = 4,
    ["tweet-attack-05"] = 5,
    ["tweet-attack-06"] = 6,
    ["tweet-attack-07"] = 7,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
