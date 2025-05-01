class_name StateMachine

extends Node

@export var current_state : state
var states: Dictionary = {idle_state:walk_state}

func ready() -> void:
	# cycle through children to identify if it is a usable state
	for child in get_children():
		if child is state:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning("State machine contains incompatible child node")
			
	current_state.enter()
	
func _process(delta: float) -> void:
	current_state.update(delta)
	#print(current_state.name)
	
func _physics_process(delta: float) -> void:	
	current_state.physics_update(delta)	
	
func on_child_transition(new_state_name: StringName) -> void:
	#set the new state to the state's name that matches the one in the dictionary
	var new_state = states.get(new_state_name)
	#if the state is not null or is found in the states dictionary
	if new_state != null:
		#if it's a different state to the one that's currently used, replace it
		if new_state != current_state:
			current_state.exit()
			new_state.enter()
			current_state = new_state
	else:
		push_warning("Invalid State being called.")
			
	
	
	
