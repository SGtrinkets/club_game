extends CharacterBody3D

@onready var head = $head
@onready var gun_anim = $head/Pistol/AnimationPlayer
@export var speed = 5.0
@export var jump = 4.5
@export var gun_equipped = false


@export var mouse_sensitivity = 0.4
var lerp_speed = 10.0

var direction = Vector3.ZERO

@onready var pistol_direction: RayCast3D = $head/Pistol/RayCast3D

var bullet = load("res://scenes/editable_bullet.tscn")
var instance

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalGameState.player = self

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("equip") and !gun_anim.is_playing():
		if !gun_equipped:
			gun_anim.play("equip_gun")
		else: 
			gun_anim.play("unequip_gun")
		gun_equipped = !gun_equipped
	GlobalGameState.gun_equipped = gun_equipped
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if gun_equipped and Input.is_action_pressed("shoot"):
		if !gun_anim.is_playing():
			gun_anim.play("Pistol_FIRE")
			instance = bullet.instantiate()
			instance.position = pistol_direction.global_position
			instance.transform.basis = pistol_direction.global_transform.basis
			get_parent().add_child(instance)
	if gun_equipped and Input.is_action_pressed("reload"):
		gun_anim.play("Pistol_RELOAD")
	move_and_slide()
