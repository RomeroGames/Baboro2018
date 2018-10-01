--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:903617d20ff74264840bf01636084f55:136235a7ae9af9a7b26ed2e1f6e15672:cf418e54b30450f149ebeac4c75afbf3$
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
            -- catbot-body-01
            x=1,
            y=1,
            width=272,
            height=256,

            sourceX = 6,
            sourceY = 0,
            sourceWidth = 278,
            sourceHeight = 256
        },
        {
            -- catbot-body-02
            x=1,
            y=259,
            width=270,
            height=254,

            sourceX = 5,
            sourceY = 0,
            sourceWidth = 278,
            sourceHeight = 256
        },
        {
            -- catbot-body-03
            x=1,
            y=515,
            width=270,
            height=254,

            sourceX = 5,
            sourceY = 0,
            sourceWidth = 278,
            sourceHeight = 256
        },
    },

    sheetContentWidth = 274,
    sheetContentHeight = 770
}

SheetInfo.frameIndex =
{

    ["catbot-body-01"] = 1,
    ["catbot-body-02"] = 2,
    ["catbot-body-03"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
