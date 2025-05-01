extends Node3D

const travel_speed = 60.0

@onready var mesh = $bullet9mm
@onready var ray = $RayCast3D
@onready var timer: Timer = $Timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0.0,0.0,-travel_speed) * delta
	if ray.is_colliding():
		#gpu_particles_3d.emitting = true
		ray.enabled = false
		if ray.get_collider().is_in_group("enemy"):
			ray.get_collider().hit()
			queue_free()
		if ray.get_collider().is_in_group("player"):
			queue_free()
			
			
func _on_timer_timeout() -> void:
	queue_free()
