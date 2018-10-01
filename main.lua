--[[-------------------------------------------------------------------------------------

Baboro 2018 - Drawn Together, a small game with tiles and characters drawn by a group of kids

5 teams, 10 kids per team

Each team's graphics will show up in 1/5 of the level

Big boss monster at the end

---------------------------------------------------------------------------------------]]
_W = display.contentWidth
_H = display.contentHeight
_XC = _W / 2
_YC = _H / 2

settings =
{
    volume_music        = 0.5,
    volume_music_mute   = false,
    volume_sfx          = 1,
    volume_sfx_mute     = false,
}

display.setStatusBar( display.HiddenStatusBar )

print( "screen width ".._W )
print( "screen height ".._H )

utils = require "utils"

music = require "music"
music.init()
music.play( "title" )

sound = require "sound"
sound.init()

physics = require "physics"
physics.start()
-- physics.setDrawMode( "hybrid" )
physics.setReportCollisionsInContentCoordinates( true)
physics.setTimeStep( 1 / 60 )

enemy = require "enemy"
boss = require "boss"

map = require "map-manager"
map:init()

camera = require "camera-manager"
camera:init()

score = require "score"
score:init()

player = require "player"
player:init()

-- boss.new(display.contentCenterX + 200, display.contentHeight/2)
