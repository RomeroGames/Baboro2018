--[[-------------------------------------------------------------------------------------

Tweet - the tweet attack effect that hits enemies

---------------------------------------------------------------------------------------]]
local T = {}

function T.newTweet(p)

    local spriteSheetInfo = require("_gfx.character.tweet-spritesheet")
    local spriteSheet = graphics.newImageSheet( "_gfx/character/tweet-spritesheet.png", spriteSheetInfo:getSheet() )

    local spriteSequenceData =
    {
        { name="tweet", start=1, count=7, time=1000, loopCount=1 },
    }

    local tweet = display.newSprite( spriteSheet, spriteSequenceData )
    physics.addBody( tweet, "dynamic", { isSensor = true } )
    tweet.name = "tweet"
    tweet.gravityScale = 0
    tweet.x = p.x + (160 * p.xScale)
    tweet.y = p.y
    local vx, vy = p:getLinearVelocity()
    tweet:setLinearVelocity(vx * 2, vy * 0.5)
    tweet.xScale = p.xScale

    tweet:setSequence( "tweet" )
    tweet:play()

    local function spriteListener( event )
        if event.phase == "ended" then
            display.remove(tweet)
        end
    end

    function tweet:collision( e )
        if e.other.name == "enemy" then
            local enemy = e.other
            local vx, vy = self:getLinearVelocity()
            enemy:setLinearVelocity(vx, 0)
            timer.performWithDelay(1, function() enemy:die() end)
        end
    end

    function tweet:postCollision( e )
    end

    tweet:addEventListener( "sprite", spriteListener )
    tweet:addEventListener( "collision" )
    tweet:addEventListener( "postCollision" )

    local m = map.get_map_display()
    m:insert( tweet )

    return tweet
end

return T