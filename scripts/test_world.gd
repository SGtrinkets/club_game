extends Node3D

@onready var anim_player = $AnimationPlayer
@onready var anim_camera = $Camera3D
@onready var cutscene1_trigger = $cutscene_1/CollisionShape3D
@export var subtitle_key = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TranslationServer.set_locale("en")
	GlobalGameState.player = $player
	#$Camera3D/Control/CenterContainer/subtitles.text = tr(subtitle_key)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Camera3D/Control/CenterContainer/subtitles.text = tr(subtitle_key)


func _on_cutscene_1_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		anim_player.play("cutscene_test_1")
		
#func set_new_subtitle(new_subtitle_key: String) -> void:
#	subtitle_key = new_subtitle_key
#	$player/head/Camera3D/Control/CenterContainer/subtitles.text = tr(subtitle_key)
