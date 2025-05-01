class_name state

extends Node

#used to communicate between the different state scripts
signal transition(new_state_name: StringName)


func enter() -> void:
	pass
	

func exit() -> void:
	pass
	
# updated every frame
func update(delta: float) -> void:
	pass
	
# physics process updated every frame
func physics_update(delta: float) -> void:
	pass
