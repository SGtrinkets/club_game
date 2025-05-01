extends Node3D

var songs = [[1, "Dwonji", "COME UP", "Single", "NoCopyrightSounds", "res://songs/level_1/Culture Code ft. Brenton Mattheus - On My Own.wav"], [2, "NATSUMI", "Take Me Away", "Single", "NoCopyrightSounds", "res://songs/level_1/NATSUMI - Take Me Away ｜ Electronic ｜ NCS - Copyright Free Music.wav"]]

var level = 1
var song_ending = true
var rng = RandomNumberGenerator.new()
var active_audio_stream
var active_song
var new_song_id

@onready var speaker_sound = $speaker_sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_song_id = rng.randi_range(0,1)
	play_song()
	

func _process(delta: float) -> void:
	if !speaker_sound.is_playing():
		#NOTE: PUT SOMETHING IN LATER TO CHECK IF PREVIOUS SONGS HAVE BEEN PLAYED
		new_song_id = rng.randi_range(0,1)
		play_song()

func play_song():
	active_audio_stream = load(songs[new_song_id][5])
	$speaker_sound.stream = active_audio_stream
	$speaker_sound.play()
	$player/head/Camera3D/song_title_screen/song_title_animation_player.play("title_fade_in_and_out")
	$player/head/Camera3D/song_title_screen/MarginContainer/VBoxContainer/artist.text = songs[new_song_id][1]
	$player/head/Camera3D/song_title_screen/MarginContainer/VBoxContainer/song_name.text = songs[new_song_id][2]
	$player/head/Camera3D/song_title_screen/MarginContainer/VBoxContainer/album.text = songs[new_song_id][3]
	$player/head/Camera3D/song_title_screen/MarginContainer/VBoxContainer/brand.text = songs[new_song_id][4]
	
