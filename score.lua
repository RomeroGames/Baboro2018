--[[-------------------------------------------------------------------------------------

Enemy - the enemies drawn by the kids

---------------------------------------------------------------------------------------]]
local S = {}

local score = 0
local displayScore = 0
local displayTimer

local starCost = 30
local numStars = 3
local lastStarScore = 0

local scoreSize = 48
local scoreUpdateSpeed = 6
local scoreText
local shadowText
local starText
local starBackgroundRect

function S:init()
    local fontParams = { text = score, x = 200, y = 6, fontSize = scoreSize, font = "godofwar.ttf" }

    local backgroundWidth = 300
    local backgroundRectOutline = display.newRoundedRect(fontParams.x-2, fontParams.y-2, backgroundWidth, scoreSize, 10)
    backgroundRectOutline:setFillColor(0,0,0)
    local backgroundRect = display.newRoundedRect(fontParams.x, fontParams.y, backgroundWidth, scoreSize, 10)
    backgroundRect:setFillColor(.6,.6,.6)

    shadowText = display.newText(fontParams)
    shadowText:setFillColor(0,0,0)
    fontParams.x = fontParams.x + 2
    fontParams.y = fontParams.y + 2
    scoreText = display.newText(fontParams)
    scoreText:setFillColor(1,1,1)

    local starFontParams = { text = "", x = 55, y = 32, fontSize = 64 }
    starText = display.newText(starFontParams)
    starText:setFillColor(1,.8,0)
    starText.anchorX = 0
    starText.anchorY = 0

    self:setScore(0)
    self:updateStarDisplay()
end

function S:reset()
    numStars = 0
    self:updateStarDisplay()
    lastStarScore = 0
    self:setScore(0)
end

function S:setScore(newScore)
    score = newScore
    displayTimer = timer.performWithDelay( 1, function() self:updateDisplayScore() end, 0 )

    if (score - lastStarScore) >= starCost then
        numStars = numStars + math.floor((score - lastStarScore) / starCost)

        self:updateStarDisplay()

        timer.performWithDelay( 100, function()
            if self.flashStars then
                starText:setFillColor(1,.8,0)
                self.flashStars = false
            else
                starText:setFillColor(1,1,1)
                self.flashStars = true
            end
        end, 8 )

        lastStarScore = score
    end
end

function S:addScore(scoreToAdd)
    self:setScore(score + scoreToAdd)
end

function S:updateDisplayScore()
    local scoreDiff
    if score > displayScore then
        scoreDiff = scoreUpdateSpeed
        displayScore = math.min(displayScore + scoreDiff, score)
    else
        scoreDiff = -scoreUpdateSpeed
        displayScore = math.max(displayScore + scoreDiff, score)
    end

    if displayScore == score then
        scoreText:setFillColor(1,1,1)
        if displayTimer ~= nil then
            timer.cancel(displayTimer)
        end
    else
        if scoreDiff > 0 then
            scoreText:setFillColor(1,.8,0)
        else
            scoreText:setFillColor(.8,0,0)
        end
    end

    local scoreString = "Score: "..tostring(displayScore)
    scoreText.text = scoreString
    shadowText.text = scoreString
end

function S:useStar()
    if numStars > 0 then
        numStars = numStars - 1
        self:updateStarDisplay()
        return true
    end

    return false
end

function S:updateStarDisplay()
    local starString = ""
    for i = 1,numStars do
        starString = starString.."★"
    end
    starText.text = starString
end

return S