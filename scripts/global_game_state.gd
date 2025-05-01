extends Node

#Here is the information of the songs of level 1 in this order:
# id, artist, name, album/single, brand, song link
var songs = [[1, "Dwonji", "COME UP", "Single", "NoCopyrightSounds", "res://songs/level_1/Culture Code ft. Brenton Mattheus - On My Own.wav"], [2, "NATSUMI", "Take Me Away", "Single", "NoCopyrightSounds", "res://songs/level_1/NATSUMI - Take Me Away ｜ Electronic ｜ NCS - Copyright Free Music.wav"]]

var level = 0
var song_ending = false
var active_song
var player
var gun_equipped = false
var player_detected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta) -> void:
	if song_ending:
		play_song()

func play_song():
	pass
