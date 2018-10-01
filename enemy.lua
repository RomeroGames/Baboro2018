--[[-------------------------------------------------------------------------------------

Enemy - the enemies drawn by the kids

---------------------------------------------------------------------------------------]]
local E = {}

local moveSpeed = 100

local spawnedEnemies = {}

function E.new(x, y, gfx, diesnd)
    local enemy = gfx
    enemy.name = "enemy"
    enemy.diesound = diesnd

    physics.addBody( enemy, "dynamic", { bounce = 0, friction = 0.1 } )
    enemy.isFixedRotation = true

    function enemy:die()
        if not self.isDead then
            sound.play( self.diesound )
            score:addScore(10)
            self.isDead = true
            self.isMoving = false
            self.isSensor = true
            enemy.isFixedRotation = false
            local randomRotation = math.random(-100,100) / 100.0
            self:applyLinearImpulse(0,-0.1, self.x + (self.width * randomRotation * 0.2), self.y)
            self.y = self.y + self.height * 0.5
            self.height = self.height * 0.5
            timer.performWithDelay( 1000, function() display.remove(self) end )
        end
    end

    function enemy:collision( e )
    end

    function enemy:postCollision( e )
    end

    function enemy:enterFrame( e )
        if not self.isMoving then
            local playerX, playerY = player:getPos()
            if self.x ~= nil and ((self.x - playerX) < (_W/3)) then
                self.isMoving = true
            end
        end

        if self.isMoving and not self.isDead then
            if not self.movingDir then
                self.movingDir = math.random(100) > 50 and -1 or 1
            end

            vx, vy = self:getLinearVelocity()
            if vx == 0 then
                self.movingDir = math.random(100) > 50 and -1 or 1
            end
            self:setLinearVelocity(moveSpeed * self.movingDir, vy)
        end
    end

    function enemy:startMoving()
        self.isMoving =  true
    end

    enemy:addEventListener( "collision" )
    enemy:addEventListener( "postCollision" )
    Runtime:addEventListener("enterFrame", enemy)

    local m = map.get_map_display()
    m:insert( enemy )

    spawnedEnemies[#spawnedEnemies+1] = enemy

    return enemy
end

function E.killAll()
    for i = 1,#spawnedEnemies do
        spawnedEnemies[i]:die()
    end
end

return E