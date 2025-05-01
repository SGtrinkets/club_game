extends Node3D

@onready var spotlight_anim = $AnimationPlayer
@onready var flash_timer = $flash_timer
@onready var light = $SpotlightHolder/Spotlight/SpotLight3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !spotlight_anim.is_playing():
		spotlight_anim.play("rotate_static")
		

func _on_flash_timer_timeout() -> void:
	#light.visible = !light.visible
	pass
	
