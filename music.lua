--[[---------------------------------------

music.lua : handle all audio

takes mp3 files

-----------------------------------------]]
-- require "globals"

local M = {}

M.songs = {
	-- title screen / story
	[ "title" ]					=	{ file = "deep-forest.mp3",			channel = 7,	kind = "title" },
}


M.playing = {}

M.audio_directory = "_music"

local reserved = 7 -- These are the channels that will be assigned to the music 

--[[---------------------------------------------------------------------------------------

init

-----------------------------------------------------------------------------------------]]
function M.init()
	print( "🎶 music: init" )
	M.playing = {}
	for i = 1,reserved do
		M.playing[ i ] = {}
		M.playing[ i ].status = "stopped"
	end
end

--[[---------------------------------------------------------------------------------------

mute on/off

-----------------------------------------------------------------------------------------]]
function M.mute( flag )
	if flag == true then
		M.set_volume( 0 )
	else
		M.set_volume( settings.volume_music )
	end
end

--[[---------------------------------------------------------------------------------------

play a song

* pauses songs on other channels
* if song on this channel was paused, song will resume
* else it will start playing song asked for

-----------------------------------------------------------------------------------------]]
function M.pause_other_channels( safe )
	for i = 1,reserved do
		if i ~= safe and M.playing[ i ].status == "playing" then
			print( "🎶 music: pausing channel "..i )
			audio.pause( i )
			M.playing[ i ].status = "paused"
		end
	end
end

function M.play( song, looping, on_complete )
	-- is this channel paused?
	local s = M.songs[ song ]
	local ch = s.channel
	local vol = settings.volume_music
	if settings.volume_music_mute == true then vol = 0 end

	if M.playing[ ch ].status == "paused" then
		-- are we trying to play the same song that's paused?
		if M.playing[ ch ].song == song then
			print( "🎶 music: resuming song "..song.." on channel "..ch )
			audio.resume( ch )
			audio.setVolume( vol, { channel = ch } )
			M.playing[ ch ].status = "playing"
			M.pause_other_channels( ch )
			return
		else -- if not, then stop it
			print( "🎶 music: stopping song "..song.." on channel "..ch )
			audio.stop( ch )
			audio.dispose( M.playing[ ch ].handle )
			M.playing[ ch ].handle = nil
			M.playing[ ch ].status = "stopped"
		end
	elseif M.playing[ ch ].status == "playing" and song == M.playing[ ch ].song then	-- song is already playing
		return
	elseif M.playing[ ch ].status == "playing" and song ~= M.playing[ ch ].song then	-- some other song is playing. kill it.
		print( "🎶 music: stopping song "..M.playing[ ch ].song.." on channel "..ch )
		audio.stop( ch )
		audio.dispose( M.playing[ ch ].handle )
		M.playing[ ch ].handle = nil
		M.playing[ ch ].status = "stopped"
	end

	-- pause all other channels
	M.pause_other_channels( ch )

	print( "🎶 music: playing song "..song.." on channel "..ch )
	M.playing[ ch ].status = "playing"
	M.playing[ ch ].song = song
	M.playing[ ch ].kind = s.kind
	M.playing[ ch ].handle = audio.loadStream( M.audio_directory.."/"..s.file )
	M.playing[ ch ].options = {}
	M.playing[ ch ].options.channel = ch
	local loop = -1
	if looping == false then 
		loop = 0 
		M.playing[ ch ].options.onComplete = on_complete
	end
	M.playing[ ch ].options.loops = loop

	audio.play( M.playing[ ch ].handle, M.playing[ ch ].options )
	audio.setVolume( vol, { channel = ch } )

--	print_r( M.playing )
end

--[[---------------------------------------------------------------------------------------

change volume of all songs playing

-----------------------------------------------------------------------------------------]]
function M.set_volume( val )
	for i = 1,reserved do
		if M.playing[ i ].status == "playing" then
			audio.setVolume( val, { channel = i } )
		end
	end
end


--[[---------------------------------------------------------------------------------------

stop playing all songs (only one is playing, really)

-----------------------------------------------------------------------------------------]]
function M.end_song()
	for i = 1,reserved do
		if M.playing[ i ].status == "playing" then
			audio.stop( i )
			audio.dispose( M.playing[ i ].handle )
			M.playing[ i ].status = "stopped"
			M.playing[ i ].handle = nil
			print( "🎶 music: stopping song "..M.playing[ i ].song.." on channel "..i )
		end
	end
end

--[[---------------------------------------------------------------------------------------

pauses any song that's playing

-----------------------------------------------------------------------------------------]]
function M.pause()
	for i = 1,reserved do
		if M.playing[ i ].status == "playing" then
			audio.pause( i )
			M.playing[ i ].status = "paused"
			print( "🎶 music: pausing song "..M.playing[ i ].song.." on channel "..i )
		end
	end
end

--[[---------------------------------------------------------------------------------------

resume a song type, the first one it finds that's paused

-----------------------------------------------------------------------------------------]]
function M.resume( song_type  )
	for i = 1,reserved do
		if M.playing[ i ].kind == song_type and M.playing[ i ].status == "paused" then
			audio.resume( i )
			M.playing[ i ].status = "playing"
			print( "🎶 music: resuming song "..M.playing[ i ].song.." on channel "..i )
			return
		end
	end
end


--[[---------------------------------------------------------------------------------------

gameplay music functions

-----------------------------------------------------------------------------------------]]




return M
