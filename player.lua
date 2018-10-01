--[[-------------------------------------------------------------------------------------

Player - the Baboro bird!

---------------------------------------------------------------------------------------]]
local P = {}

local birdWeight = 0.5
local flapPower = 0.2
local divePower = 2
local flySpeed = 250

local maxSpeed = 250
local maxFlyUpVelocity = 1
local maxDiveVelocity = 1000000

local player
local playerRadius

local upKeyDown = false
local downKeyDown = false
local leftKeyDown = false
local rightKeyDown = false

local keyPressMap = {}

function P:init()

    local spriteSheetInfo = require("_gfx.character.babby-spritesheet")
    local spriteSheet = graphics.newImageSheet( "_gfx/character/babby-spritesheet.png", spriteSheetInfo:getSheet() )

    local spriteSequenceData =
    {
        { name="fly", start=1, count=6, time=300 },
        { name="dive", start=7, count=1, time=1000 },
        { name="stomp", start=8, count=1, time=1000 },
        { name="idle", start=9, count=6, time=1000 },
        { name="tweet", start=15, count=2, time=200, loopCount=1 },
        { name="run", start=17, count=6, time=400 },
    }

    player = display.newSprite( spriteSheet, spriteSequenceData )
    player.name = "player"

    playerRadius = 40
    physics.addBody( player, "dynamic", { radius = playerRadius, bounce = 0, friction = 0 } )
    player.isFixedRotation = true

    player.update = P.update

    Runtime:addEventListener( "key", self.onKeyEvent )
    player:addEventListener( "collision", self.onCollision )
    player:addEventListener( "postCollision", self.onPostCollision )
    Runtime:addEventListener("enterFrame", self)

    local m = map.get_map_display()
    m:insert( player )

    self:respawn()
end

function P:getPos()
    return player.x, player.y
end

function P:respawn()
    player:setSequence( "fly" )
    player:play()
    player:setLinearVelocity(0,0)
    P.flap_channel = sound.play( "babbyflap" )
    sound.play( "babbychirp" )

    -- player.x = 9000
    player.x = math.max(350, player.x - 200)
    player.y = 100
    player.yScale = 1
    player.isSensor = false
    player.gravityScale = birdWeight
    player.isDead = false
    player.isInvincible = true
    player:setFillColor(1,1,1,0.4)

    timer.performWithDelay( 100, function()
        if player.flashInvincible then
            player:setFillColor(1,1,1,0.5)
            player.flashInvincible = false
        else
            player:setFillColor(1,1,1,1)
            player.flashInvincible = true
        end
    end, 18 )

    timer.performWithDelay( 2000, function()
        player.isInvincible = false
        player.flashInvincible = false
        player:setFillColor(1,1,1,1)
    end )
 end

function P:updateAnimationState()

    player.prevAnimTime = player.currAnimTime or 0
    player.currAnimTime = system.getTimer()
    local deltaTime = (player.currAnimTime - player.prevAnimTime) / 1000

    local vx, vy = player:getLinearVelocity()

    if vx < -0.01 then
        player.xScale = -1
    elseif vx > 0.01 then
        player.xScale = 1
    end

    if player.state ~= "diving" and player.state ~= "stomping" then
        if player.state == "grounded" and math.abs(vx) > 0.01 then
            player.state = "running"
        elseif (math.abs(vy) > 0.01) then
            player.state = "flying"
        end
    end

    if player.tweeting then
        player.state = "tweeting"
    end

    if player.state ~= player.prevState then
        player.prevState = player.state

        -- print("----------------------------------------", player.state)
        if player.state == "flying" then
            player:setSequence( "fly" )
            player:play()
        elseif player.state == "grounded" then
            player:setSequence( "idle" )
            player:play()
            sound.stop( "babbyflap", P.flap_channel )
            player.timeScale = 1
        elseif player.state == "running" then
            player:setSequence( "run" )
            player:play()
        elseif player.state == "diving" then
            player:setSequence( "dive" )
            player:play()
        elseif player.state == "stomping" then
            player:setSequence( "stomp" )
            player:play()
            timer.performWithDelay( 75, function() player.state = "flying" end )
        elseif player.state == "tweeting" then
            player:setSequence( "tweet" )
            player:play()
            timer.performWithDelay( 500, function() player.state = "grounded" player.tweeting = false end )
        end
    end

    if player.state == "running" then
        player.timeScale = math.pow((math.abs(vx) / maxSpeed), 0.5)
    elseif player.state == "flying" then
        player.timeScale = 1
    end

end

function P:die()
    if not player.isDead then
        player.deadPos = {x = player.x, y = player.y}
        sound.play( "babbycrunch" )
        timer.performWithDelay( 500, function() sound.play( "babbydie" ) end )
        sound.stop( "babbyflap", P.flap_channel )
        player.isDead = true
        player.isSensor = true

        player:setSequence( "fly" )
        player:setFrame(1)
        player:pause()

        local randomRotation = math.random(-50,50) / 100.0
        player:setLinearVelocity(0,0)
        player:applyLinearImpulse(0,-0.2, player.x, player.y)
        player.yScale = -1
        player.gravityScale = player.gravityScale * 5
        timer.performWithDelay( 3000, function()
            self:respawn()
            score:reset()
        end )
    end
end

function P.onKeyEvent( e )
    local prevState = keyPressMap[e.keyName] or "up"
    keyPressMap[e.keyName] = e.phase
    local keyPressed = ((keyPressMap[e.keyName] == "down") and prevState == "up")

    if player.isDead then
        return true
    end

    if ( e.keyName == "up" and keyPressed ) then
        player:applyLinearImpulse( nil, -flapPower, player.x, player.y )
        local vx, vy = player:getLinearVelocity()
        player:setLinearVelocity(vx, math.min(vy, maxFlyUpVelocity))
        player.state = "flying"
        P.flap_channel = sound.play( "babbyflap" )
    end

    if ( e.keyName == "down" and keyPressed ) then
        player:applyLinearImpulse( nil, divePower, player.x, player.y )
        player.state = "diving"
        sound.stop( "babbyflap", P.flap_channel )
        sound.play( "babbyattack" )
    end

    if ( e.keyName == "space" and keyPressed ) then
        if score:useStar() then
            player.tweeting = true
            require("tweetAttack").newTweet(player)
            sound.stop( "babbyflap", P.flap_channel )
            sound.play( "tweet" )
        end
    end

    return true
end

function P.onCollision( e )
    if ( e.phase == "began" ) then
        local playerBottom = player.y + (playerRadius * 0.5)
        local isContactBelow = (e.y > playerBottom)
        if e.other.name == "enemy" then
            if isContactBelow and not e.other.isDead then
                player.state = "stomping"
                timer.performWithDelay(1, function()
                    local vx, vy = player:getLinearVelocity()
                    e.other:die()
                    player:setLinearVelocity(vx, -maxSpeed)
                    sound.play( "babbybop" )
                end)
            elseif not e.other.isDead and not player.isInvincible then
                P:die()
            end
        end
    end
end

function P.onPostCollision( e )
    local playerBottom = player.y + (playerRadius * 0.75)
    local isContactBelow = (e.y > playerBottom)
    if isContactBelow and e and e.contact and e.force < 0.1 then
        e.contact.friction = 4
        player.state = "grounded"
    end
end

function P.enterFrame( e )
    if player.isDead then
        return
    end

    local vx, vy = player:getLinearVelocity()

    local keyPressed = false

    if ( keyPressMap["left"] == "down" ) then
        player:setLinearVelocity(-flySpeed, vy)
        keyPressed = true
        P.flap_channel = sound.play( "babbywalk" )
    end

    if ( keyPressMap["right"] == "down" ) then
        player:setLinearVelocity(flySpeed, vy)
        keyPressed = true
        P.flap_channel = sound.play( "babbywalk" )
    end

    if keyPressed then
        local vx, vy = player:getLinearVelocity()
        vx = utils.clamp(vx, -maxSpeed, maxSpeed)
        player:setLinearVelocity(vx, vy)
    end

    camera:move_camera( player )

    P:updateAnimationState()
end

return P