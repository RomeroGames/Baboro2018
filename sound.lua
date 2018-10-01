--[[---------------------------------------

sound.lua : handle all audio

-----------------------------------------]]
-- require "globals"

local A = {}

A.audio_files = {
	-- title
	[ "tweet" ]						= { file = "tweet.mp3"						},
	[ "monsterdie-1" ]				= { file = "monster-die-1.mp3"				},
	[ "monsterdie-2" ]				= { file = "monster-die-2.mp3"				},
	[ "monsterdie-3" ]				= { file = "monster-die-3.mp3"				},
	[ "monsterdie-4" ]				= { file = "monster-die-4.mp3"				},
	[ "monsterdie-5" ]				= { file = "monster-die-5.mp3"				},
	[ "babbydie" ]					= { file = "babby-die.wav"					},
	[ "babbyattack" ]				= { file = "babby-attack.mp3"				},
	[ "babbybop" ]					= { file = "babby-bop.mp3"					},
	[ "babbychirp" ]				= { file = "babby-chirp.mp3"				},
	[ "babbycrunch" ]				= { file = "babby-crunch.mp3"				},
	[ "babbyland" ]					= { file = "babby-land.mp3"					},
	[ "babbyflap" ]					= { file = "babby-flap.mp3", options = { channel = 29, loops = -1 }				},
	[ "babbywalk" ]					= { file = "babby-walk.mp3", options = { channel = 29, loops = -1 }				},
	-- [ "thunder" ]				= { file = "thunder.mp3",			options = { channel = 29, loops = -1 } },
	-- [ "shop-fan-golden" ]		= { file = "shop/golden-fan-loop.wav",				options = { channel = 29, loops = -1 } },
	-- [ "truckloop" ]				= { file = "action/truck_loop.wav",					options = { channel = 30, loops = -1 } },

	-- [ "gameover-burning" ]		= { file = "action/gameover-burning.wav",			options = { channel = 30, loops = -1 } },

	-- [ "slot-roll-spinning" ]	= { file = "shop/slot-spin.wav",					options = { channel = 27, loops = -1 } },

}

A.sound_path  = "_sfx"

--[[------------------------------------------
keep sounds from repeating by keeping track of their usage (generic)
--------------------------------------------]]
function A.non_repeat( t, max )
	local index
	local tries = 200
	repeat
		index = rnd( 1, max )
		tries = tries - 1
	until not t[ index ] or tries == 0
	t[ index ] = true

	if tries == 0 then
		local name
		if t.n then	name = t.n end
		local lc = t.last_chosen
		t = {}
		if name then t.n = name else name = "<no name>" end
		t[ lc ] = true
		repeat
			index = rnd( 1, max )
		until not t[ index ]
		t[ index ] = true
		log( "NON-REPEAT: "..name.." just filled up. emptying to start over." )
	else
		t.last_chosen = index
	end
	return index
end

--[[------------------------------------------
load the sfx files
--------------------------------------------]]
local function load_audio( )
	print( "Loading audio files..." )
	for i,v in pairs( A.audio_files ) do
		if v.handle then audio.dispose( v.handle ) end
		if v.file ~= nil then v.handle = audio.loadSound( A.sound_path .. "/" .. v.file ) end
		if v.handle ~= nil then print( "loaded sound: "..v.file ) end
	end
end

local function async_audio_loader( )

	local sound_count = tablesize( A.audio_files )
	local processed_sounds = 0

	local sounds_per_frame = 4
	local counter = sounds_per_frame
	for i,v in pairs( A.audio_files ) do

		if not v.handle then 
			if v.file then 
				v.handle = audio.loadSound( A.sound_path .. "/" .. v.file ) 
			end
			if v.handle then 
				print( "loaded sound: " .. v.file ) 
			else
				print( "failed to load sound: " .. v.file, err )
			end
		end
		counter = counter - 1
		processed_sounds = processed_sounds + 1

		if counter == 0 then 
			counter = sounds_per_frame
			coroutine.yield( false, processed_sounds / sound_count )
		end
	end

	return true, 1 
end

local function load_audio_coroutine( on_complete )

	print( "Beginning audio load coroutine" )
	local audio_coroutine = coroutine.create( async_audio_loader )
	coroutine.resume( audio_coroutine )
	A.percent_loaded = 0

	-- Set up the frame listener to process the coroutine
	local function crono_frame( )

		local status, finished, percent = coroutine.resume( audio_coroutine )

		A.percent_loaded = percent

		if finished then 

			if on_complete then 
				on_complete( )
			end

			Runtime:removeEventListener( "enterFrame", crono_frame )

		end

		if not status then 
			Runtime:removeEventListener( "enterFrame", crono_frame )
		end

	end 

	Runtime:addEventListener( "enterFrame", crono_frame )

end

--[[------------------------------------------
init the sfx code
--------------------------------------------]]
function A.init( async, on_complete )
	print( "sound initialized..." )
	if on_complete then
		on_complete( )
	end
	load_audio()

	-- if async then 
	-- 	load_audio_coroutine( on_complete )
	-- else
	-- 	-- load_audio( )
	-- 	if on_complete then
	-- 		on_complete( )
	-- 	end
	-- end
end


function A.load_specific( sound )

	print( "Preloading " .. sound )

	if A.audio_files[ sound ] then 
		local snd = A.audio_files[ sound ].handle
		if not snd then -- Attempt to load it
			local audio_data = A.audio_files[ sound ]
			audio_data.handle = audio.loadSound( A.sound_path .. "/" .. audio_data.file )
			if audio_data.handle ~= nil then 
				print( "loaded sound: " .. audio_data.file )
				snd = audio_data.handle
			end
		end
	end

end

--[[------------------------------------------
play a sound effect
--------------------------------------------]]
function A.play( sound, volume )
	local channel = nil
	-- get sound handle
	if A.audio_files[ sound ] == nil then print( "SOUND INDEX DOESN'T EXIST: " .. tostring( sound ) ) return end
	local snd = A.audio_files[ sound ].handle
	if not snd then -- Attempt to load it
		local audio_data = A.audio_files[ sound ]
		audio_data.handle = audio.loadSound( A.sound_path .. "/" .. audio_data.file )
		if audio_data.handle ~= nil then 
			print( "loaded sound: " .. audio_data.file )
			snd = audio_data.handle
		end
	end
	if snd ~= nil then
		-- get options if they exist
		local o = A.audio_files[ sound ].options
		-- modify sound volume?
		local vol = settings.volume_sfx
		if volume then
			vol = vol * volume
		end
		if settings.volume_sfx_mute == true then
			vol = 0
		end
		-- if we have options...
		if o ~= nil then
			-- if sound is already playing, don't try to play again
			if audio.isChannelPlaying( o.channel ) == true then
				audio.stop( o.channel )
				print( "audio: channel already playing -- STOPPED" )
			end

			channel = audio.play( snd, o )

			if channel ~= 0 then 
				audio.setVolume( vol , { channel = channel } )
--				log( "audio: playing sound "..sound.." on channel "..channel )
			else
				print( "audio: could not play " .. sound )
			end
		-- otherwise just play the sound
		else 
			channel = audio.play( snd )

			if channel == 0 then 
				print( "audio: could not play " .. sound ) 
			else
				A.audio_files[ sound ].temp_channel = channel
				audio.setVolume( vol , { channel = channel } )
			end
		end
		if debug_development_mode == true and debug_show_every_sound == true then
			debug_highlight( "sound: "..sound )
		end
--		log( "audio: playing sound "..sound.." on channel "..channel )
	else
		print( "audio: failed playing sound " .. sound )
	end
--	log( "audio: using channel "..channel )
	return channel
end

--------------------------------------------
-- sounds that stop must have a channel in options
--------------------------------------------
function A.stop( sound, channel )
--	log( "STOP playing sound "..sound )
	if A.audio_files[ sound ] == nil then log( "SOUND INDEX DOESN'T EXIST: " .. tostring( sound ), err ) return end

	if channel then
		audio.stop( channel )
		return
	end

	local snd = A.audio_files[ sound ].options
	if snd ~= nil and snd.channel ~= nil and audio.isChannelPlaying( snd.channel ) == true then 
		audio.stop( snd.channel )
	elseif A.audio_files[ sound ].temp_channel then
		audio.stop( A.audio_files[ sound ].temp_channel )
		A.audio_files[ sound ].temp_channel = nil
	end
end

--------------------------------------------
-- stop a channel from playing directly
--------------------------------------------
function A.stop_sound( channel )
	audio.stop( channel )
end

--------------------------------------------
-- update any looping effects
--------------------------------------------
function A.set_volume( v )

	-- Check for the truck loop
	if audio.isChannelPlaying( A.audio_files[ "truckloop" ].options.channel ) then
		audio.setVolume( v, { channel = A.audio_files[ "truckloop" ].options.channel } )
	end

end

function A.mute( state )

	if state then 
		A.set_volume( 0 )
	else
		A.set_volume( settings.volume_sfx )
	end

end


return A
