--[[-------------------------------------------------------------------------------------

map manager : handles loading map and tileset

---------------------------------------------------------------------------------------]]
local G = {}

local mappings =
{   -- these are only used for the spawned objects (not tiles):
    -- bush, cloud, fence, flower, pickup, tree
    [01] = "tiles/s1-grass.png",
    [02] = "tiles/s1-plant.png",
    [03] = "tiles/s1-floating.png",
    [04] = "tiles/s1-rock.png",
    [05] = "tiles/s1-tree.png",
    [06] = "tiles/s1-fence.png",
    [07] = "tiles/s1-cloud.png",
    [08] = "tiles/s1-bush.png",
    [09] = "tiles/s1-pickup.png",
    [10] = "tiles/s1-flower.png",

    [11] = "tiles/s2-grass.png",
    [12] = "tiles/s2-plant.png",
    [13] = "tiles/s2-floating.png",
    [14] = "tiles/s2-rock.png",
    [15] = "tiles/s2-tree.png",
    [16] = "tiles/s2-fence.png",
    [17] = "tiles/s2-cloud.png",
    [18] = "tiles/s2-bush.png",
    [19] = "tiles/s2-pickup.png",
    [20] = "tiles/s2-flower.png",

    [21] = "tiles/s3-grass.png",
    [22] = "tiles/s3-plant.png",
    [23] = "tiles/s3-floating.png",
    [24] = "tiles/s3-rock.png",
    [25] = "tiles/s3-tree.png",
    [26] = "tiles/s3-fence.png",
    [27] = "tiles/s3-cloud.png",
    [28] = "tiles/s3-bush.png",
    [29] = "tiles/s3-pickup.png",
    [30] = "tiles/s3-flower.png",

    [31] = "tiles/s4-grass.png",
    [32] = "tiles/s4-plant.png",
    [33] = "tiles/s4-floating.png",
    [34] = "tiles/s4-rock.png",
    [35] = "tiles/s4-tree.png",
    [36] = "tiles/s4-fence.png",
    [37] = "tiles/s4-cloud.png",
    [38] = "tiles/s4-bush.png",
    [39] = "tiles/s4-pickup.png",
    [40] = "tiles/s4-flower.png",

    [41] = "tiles/s5-grass.png",
    [42] = "tiles/s5-plant.png",
    [43] = "tiles/s5-floating.png",
    [44] = "tiles/s5-rock.png",
    [45] = "tiles/s5-tree.png",
    [46] = "tiles/s5-fence.png",
    [47] = "tiles/s5-cloud.png",
    [48] = "tiles/s5-bush.png",
    [49] = "tiles/s5-pickup.png",
    [50] = "tiles/s5-flower.png",

    -- monster spawns
    [51] = "enemy/boss-monster.png",
    [52] = "enemy/s1-monster-",
    [53] = "enemy/s2-monster-",
    [54] = "enemy/s3-monster-",
    [55] = "enemy/s4-monster-",
    [56] = "enemy/s5-monster-",
}

-- these objects should float in the air
local floating =
{
    [09] = true,
    [19] = true,
    [29] = true,
    [39] = true,
    [49] = true,
}

-- these are enemies
local enemies =
{
    [52] = 1,
    [53] = 1,
    [54] = 1,
    [55] = 1,
    [56] = 1,
}
local enemysound =
{
    [51] = "monsterdie-boss",
    [52] = "monsterdie-1",
    [53] = "monsterdie-2",
    [54] = "monsterdie-3",
    [55] = "monsterdie-4",
    [56] = "monsterdie-5",
}

-- is this a boss?
local bossTile =
{
    [51] = true
}

--[[-------------------------------------------------------------------------------------
return the map display group/object
---------------------------------------------------------------------------------------]]
function G:get_map_display()
    return G.map
end

--[[-------------------------------------------------------------------------------------
return the pixel width, height of the entire map
---------------------------------------------------------------------------------------]]
function G:get_map_size()
    return G.map_pixelwidth, G.map_pixelheight
end

--[[-------------------------------------------------------------------------------------
return the gfx of a random enemy type
---------------------------------------------------------------------------------------]]
function G:get_random_enemy_gfx()

end

--[[-------------------------------------------------------------------------------------
check for map scrolling
IN: xcoord of relevant character
---------------------------------------------------------------------------------------]]
function G:set_position( x, y )
    G.map.x, G.map.y = x, y
    G.objs.x, G.objs.y = x, y
end

--[[-------------------------------------------------------------------------------------
return the pixel width, height of the entire map
---------------------------------------------------------------------------------------]]
function G:get_pickups()
    return G.pickup_items
end

--[[-------------------------------------------------------------------------------------
make something float
---------------------------------------------------------------------------------------]]
function G.float2( obj )
    local ny = obj.y + 5
    transition.to( obj, { y = ny, time = 500, onComplete = function() G.float( obj ) end, transition = easing.inOutBack } )
end
function G.float( obj )
    local ny = obj.y - 5
    transition.to( obj, { y = ny, time = 500, onComplete = function() G.float2( obj ) end, transition = easing.inOutBack } )
end

--[[-------------------------------------------------------------------------------------
init the class
---------------------------------------------------------------------------------------]]
function G:init()
    -- setup map sprite imagesheet
    local op =
    {
        width = 64,
        height = 64,
        numFrames = 50,
    }
    -- load the imagesheet
    G.tile_sheet = graphics.newImageSheet( "_gfx/tiles/tiles.png", op )
    -- load the actual map data
    G.map_data = require "_gfx.tiles.map"
    -- create the display group
    G.objs = display.newGroup()
    G.map = display.newGroup()
    -- set some vars
    G.map_width = G.map_data.layers[ 1 ].width
    G.map_height = G.map_data.layers[ 1 ].height
    G.map_pixelwidth = G.map_width * op.width
    G.map_pixelheight = G.map_height * op.height
    -- create a white background image behind the map
    local bg = display.newRect( G.objs, G.map_pixelwidth / 2, G.map_pixelheight / 2, G.map_pixelwidth, G.map_pixelheight )
    bg:setFillColor( 0.8, 0.8, 0.8 )

    -- these are the pickup items
    G.pickup_items = {}

    print( "map version "..G.map_data.version )
    print( "map width "..G.map_width )
    print( "map height "..G.map_height )
    -- find the map data layer
    local layer = G.map_data.layers[ 1 ].data
    local objs = G.map_data.layers[ 2 ].data

    -- iterate through the array and draw the entire map into the group
    for j = 1, G.map_data.layers[ 1 ].height do
        for i = 1, G.map_data.layers[ 1 ].width do
            local index = ( j - 1 ) * G.map_width + i

            -- background tiles
            local t = layer[ index ]
            local x = ( i - 1 ) * op.width + op.width / 2
            local y = ( j - 1 ) * op.height - op.height / 2
            if t > 0 then
                local im = display.newImage( "_gfx/"..mappings[ t ], x, y )
                if t ~= 2 then
                    physics.addBody( im, "static", { friction=0.5, bounce=0  } )
                end
                G.map:insert( im )
            end

            -- foreground tiles
            local ob = objs[ index ]
            if ob > 0 then
                if not mappings[ ob ] or mappings[ ob ] == "" then print( "unsupported tile "..ob ) end
                local obim
                if not enemies[ ob ] and not bossTile[ ob ] then
                    obim = display.newImage( G.objs, "_gfx/"..mappings[ ob ], x, y )
                    -- center object at bottom/center of tile instead of tile center
                    obim.anchorY = 1.0
                    obim.y = obim.y + op.height / 2
                end

                -- handle floating objects
                if floating[ ob ] then
                    timer.performWithDelay( math.random( 1000 ), function() G.float( obim ) end )
                    table.insert( G.pickup_items, obim )

                -- spawn an enemy?
                elseif enemies[ ob ] then
                    local name = "_gfx/"..mappings[ ob ]..enemies[ ob ]..".png"
                    print( "spawning "..name )
                    obim = display.newImage( G.objs, name, x, y )
                    enemies[ ob ] = enemies[ ob ] + 1
                    enemy.new( x, y, obim, enemysound[ ob ] )

                -- spawn the boss
                elseif bossTile[ ob ] then
                    print( "spawning boss" )
                    boss.new( x, y - 200 )
                end
            end
        end
    end
    G.map.y = -op.height/2
    G.objs.y = G.map.y

    print( "map manager initialized..." )
end

return G
