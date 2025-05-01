class_name idle_state

extends state

# Called every frame to check if the velocity is still 0.
func update(delta: float) -> void:
	if GlobalGameState.player.velocity.length() > 0.0:
		transition.emit("walk_state")
