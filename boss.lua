--[[-------------------------------------------------------------------------------------

Boss - the final boss enemy

---------------------------------------------------------------------------------------]]
local B = {}

local headPos = { x = 0, y = -105, anchorX = 0.5, anchorY = 1}
local armLeftPos = { x = 130, y = -45, anchorX = 0.12, anchorY = 0.48}
local armRightPos = { x = -110, y = -60, anchorX = 0.93, anchorY = 0.93}
local legLeftPos = { x = 105, y = 115, anchorX = 0.09, anchorY = 0.38}
local legRightPos = { x = -100, y = 115, anchorX = 0.9, anchorY = 0.35}

local enemySpawnRate = 3000 -- seconds between spawns
local openAnimationTime = 1000

local enemyGfx =
{
    "_gfx/enemy/s1-monster-",
    "_gfx/enemy/s2-monster-",
    "_gfx/enemy/s3-monster-",
    "_gfx/enemy/s4-monster-",
    "_gfx/enemy/s5-monster-",
}

function B.new(x, y)
    local boss = display.newGroup()
    boss.x = x
    boss.y = y
    boss.name = "boss"
    physics.addBody( boss, "kinematic", { radius = 150 , isSensor = true } )

    local bodySpriteSheetInfo = require("_gfx.character.catbot-body-spritesheet")
    local bodySpriteSheet = graphics.newImageSheet( "_gfx/character/catbot-body-spritesheet.png", bodySpriteSheetInfo:getSheet() )

    local bodySpriteSequenceData =
    {
        { name="open", start=1, count=3, time=openAnimationTime, loopCount=1, loopDirection = "bounce" },
    }

    local body = display.newSprite( bodySpriteSheet, bodySpriteSequenceData )
    body.name = "boss-body"
    body.life = 5

    local head = display.newImage( "_gfx/character/catbot-head.png" )
    head.name = "boss-head"
    head.x = -9
    head.y = -138

    local function createBodyPart(image, posTable, name)
        local o = display.newImage( "_gfx/character/"..image, posTable.x, posTable.y )
        o.name = name
        o.anchorX = posTable.anchorX
        o.anchorY = posTable.anchorY
        return o
    end

    local head = createBodyPart("catbot-head.png", headPos, "boss-head")
    local armLeft = createBodyPart("catbot-arm-left.png", armLeftPos, "boss-arm-left")
    local armRight = createBodyPart("catbot-arm-right.png", armRightPos, "boss-arm-right")
    local legLeft = createBodyPart("catbot-leg-left.png", legLeftPos, "boss-leg-left")
    local legRight = createBodyPart("catbot-leg-right.png", legRightPos, "boss-leg-right")

    boss:insert( head )
    boss:insert( armLeft )
    boss:insert( armRight )
    boss:insert( legLeft )
    boss:insert( legRight )
    boss:insert( body )

    local function idleRandomRotate(obj, minRot, maxRot, minT, maxT)
        local rot = math.random(minRot,maxRot)
        local t = math.random(minT,maxT)
        obj.rotationTransition = transition.to( obj, { rotation = rot, time = t, onComplete = function() idleRandomRotate( obj, minRot, maxRot, minT, maxT ) end, transition = easing.inOutBack } )
    end

    idleRandomRotate(head, -10, 10, 500, 2000)
    idleRandomRotate(armLeft, -20, 20, 500, 2000)
    idleRandomRotate(armRight, -20, 45, 500, 2000)
    idleRandomRotate(legLeft, -20, 20, 500, 2000)
    idleRandomRotate(legRight, -20, 20, 500, 2000)

    function boss:startSpawning()
        timer.performWithDelay( enemySpawnRate, function() boss:spawnEnemy() end, 0 )
    end

    function boss:collision( e )
        if e.other.name == "tweet" then
            timer.performWithDelay( 1, function() physics.removeBody(e.other) end )
            timer.performWithDelay( 100, function()
                if not body.isDead then
                    if body.flash then
                        body:setFillColor(1,0,0)
                        body.flash = false
                    else
                        body:setFillColor(1,1,1)
                        body.flash = true
                    end
                end
            end, 9 )
            timer.performWithDelay( 1000, function()
                if not body.isDead then
                    body:setFillColor(1,1,1)
                end
            end, 1 )

            body.life = body.life - 1
            print("Boss life: ",body.life)

            local function destroyBodyPart(part, offsetX, offsetY)
                transition.cancel(part.rotationTransition)
                transition.to(part, {time = 500, delta=true, x = offsetX, y = offsetY })
                transition.to(part, {time = 500, delta=true, rotation = -180 })
                timer.performWithDelay( 500, function() display.remove(part) end )
            end

            if body.life == 4 then
                destroyBodyPart(armRight, -300, 300)
            elseif body.life == 3 then
                destroyBodyPart(armLeft, 300, 300)
            elseif body.life == 2 then
                destroyBodyPart(legRight, -300, 300)
            elseif body.life == 1 then
                destroyBodyPart(legLeft, 300, 300)
            elseif body.life == 0 then
                body.isDead = true
                destroyBodyPart(head, 0, -300)
                destroyBodyPart(body, 0, 300)
                timer.performWithDelay( 1, function() enemy.killAll() end )
                timer.performWithDelay( 2000, function()
                    local blackBox = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth, display.contentHeight*2)
                    blackBox:setFillColor(0,0,0,1)
                    local winText = display.newText({ text = "You win!", x = display.contentWidth / 2, y = 100, fontSize = 128, font = "godofwar.ttf" } )
                    timer.performWithDelay( 2500, function()
                        display.remove(winText)
                    end )
                    require("credits").rollCredits()
                end )
            end
        end
    end

    function boss:postCollision( e )
    end

    function boss:enterFrame( e )
        if not self.isSpawning then
            local playerX, playerY = player:getPos()
            if (self.x - playerX) < (_W/3) then
                self:startSpawning()
                self.isSpawning = true
            end
        end
    end

    local function spriteListener( e )
        local spawnPhase = "bounce"
        if (openAnimationTime < 100) then
            spawnPhase = "began"
        end

        if e.phase == spawnPhase then
            local gfx = enemyGfx[ math.random( #enemyGfx ) ]
            local enemyNumber = math.random(1,10)
            local gfxFile = gfx..enemyNumber..".png"
            local enemyObject = display.newImage( gfxFile, boss.x, boss.y )
            local enemy = require("enemy").new(boss.x, boss.y, enemyObject)
            local randomSpawnDir = math.random(100) > 50 and -1 or 1
            local randomSpawnSpeed = math.random() * 0.5
            enemy:applyLinearImpulse(randomSpawnDir * randomSpawnSpeed, 0, enemy.x, enemy.y)
            timer.performWithDelay( 1000, function() enemy:startMoving() end )
        end
    end

    function boss:spawnEnemy()
        if not body.isDead then
            body:setSequence("open")
            body:play()
        end
    end

    boss:addEventListener( "collision" )
    boss:addEventListener( "postCollision" )
    body:addEventListener( "sprite", spriteListener )
    Runtime:addEventListener("enterFrame", boss)

    local m = map.get_map_display()
    m:insert( boss )

    return boss
end

return B