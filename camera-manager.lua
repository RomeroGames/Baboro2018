--[[-------------------------------------------------------------------------------------

camera manager : handles moving the camera

assumed globals: map

---------------------------------------------------------------------------------------]]
local C = {}


--[[-------------------------------------------------------------------------------------
init the class
---------------------------------------------------------------------------------------]]
function C:init()
    C.camera_x = 0
    C.camera_y = 0
    C.xmin = _XC * 0.5
    C.xmax = _XC * 1.5

    -- debugging
    -- _LEFTLINE = display.newLine( C.xmin, 0, C.xmin, _H )
    -- _RIGHTLINE = display.newLine( C.xmax, 0, C.xmax, _H )
    -- _LEFTLINE:setStrokeColor( 1,0,0 )
    -- _RIGHTLINE:setStrokeColor( 1,0,0 )
    
    print( "camera manager initialized..." )
end

--[[-------------------------------------------------------------------------------------
check for item pickups
IN: the player (for coords)
---------------------------------------------------------------------------------------]]
function C:check_for_points( obj )
    local p = map.get_pickups()
    local x1 = obj.x
    local x2 = obj.x + obj.width
    local y1 = obj.y
    local y2 = obj.y + obj.height
    for i = 1, #p do
        local t = p[ i ]
        local tx1 = t.x
        local tx2 = t.x + t.width
        local ty1 = t.y
        local ty2 = t.y + t.height

        -- if 
    end
end

--[[-------------------------------------------------------------------------------------
move the camera (for dragging)
---------------------------------------------------------------------------------------]]
function C:move_delta( dx, dy )
    C.camera_x = C.camera_x - dx
    C.camera_y = C.camera_y - dy
    local w, h = map:get_map_size()
    if C.camera_x < -w then C.camera_x = -w end
    if C.camera_y < -h then C.camera_y = -h end
    local m = map:get_map_display()
    m.x = C.camera_x
    m.y = C.camera_y
    -- print( "camera deltax,y = "..dx, dy.." / x,y = "..C.camera_x, C.camera_y)
end

--[[-------------------------------------------------------------------------------------
should the camera tell the map to scroll?
IN: xcoord of object trying to scroll - local screen coords
---------------------------------------------------------------------------------------]]
function C:move_camera( obj )
    local m = map:get_map_display()
    local width, height = map:get_map_size()
    local xc = obj.x - math.abs( m.x ) -- screen-space xcoord of camera
    -- trying to scroll left?
    if xc < C.xmin then
        if m.x < 0 then     -- is map still left of origin? if so, scroll
            local dx = C.xmin - xc
            map:set_position( m.x + dx, m.y )
        end
    -- trying to scroll right?
    elseif xc > C.xmax then
        if math.abs( m.x ) < width - _W then  -- does map still have more to show on right side? if so, scroll
            local dx = C.xmax - xc
            map:set_position( m.x + dx, m.y )
        end 
    end

    -- see if player picked up any pickup items
--    C:check_for_points( obj )

end

return C