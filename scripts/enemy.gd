extends CharacterBody3D



@export var speed = 3.0
@export var sprint_speed = 5.0
@export var attack_range = 2.5
var isChasing = false
@onready var hit_stagger_timer = $hit_stagger
var hit_by_bullet = false
var player_detected = GlobalGameState.player_detected
var player_in_close_range = false
var player_in_long_range = false
var player_in_attack_range = false
@export var health = 9.0
var is_dead = false

var player = null
var player_in_range = false
var nav_agent

var rng = RandomNumberGenerator.new()
var wait_shoot_time
var active_shoot = false
@onready var shoot_trigger = $shoot_trigger

@export var player_path : NodePath
@onready var navigation_agent = $NavigationAgent3D

@onready var anim_play = $AnimationPlayer
@onready var anim_tree = $AnimationTree
var state_machine

func _ready() -> void:
	player = GlobalGameState.player
	state_machine = anim_tree.get("parameters/playback")

func _physics_process(delta: float) -> void:
	velocity = Vector3.ZERO
	match state_machine.get_current_node():
		"idle":
			pass
		"walk":
			navigation_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = navigation_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * speed
			look_at(Vector3(player.global_position.x + velocity.x, global_position.y, player.global_position.z + velocity.z), Vector3.UP)
			if player_in_close_range and shoot_trigger.is_stopped():
				wait_shoot_time = rng.randi_range(0,3)
				shoot_trigger.start(wait_shoot_time)
			if player_in_long_range and !player_in_close_range and shoot_trigger.is_stopped():
				wait_shoot_time = rng.randi_range(2,6)
				shoot_trigger.start(wait_shoot_time)
			self.rotation.x = 0
		"gun_whip":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		"shoot":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			if anim_play.current_animation_changed:
				active_shoot = false
				wait_shoot_time = rng.randi_range(0,3)
				shoot_trigger.start(wait_shoot_time)
			
			
	if GlobalGameState.gun_equipped and player_in_range:
		#GlobalGameState.player_detected = !GlobalGameState.player_detected
		player_detected = true
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	anim_tree.set("parameters/conditions/no_player_detected", !player_detected)
	anim_tree.set("parameters/conditions/player_detected", player_detected)
	anim_tree.set("parameters/conditions/melee", _target_in_melee_range())
	anim_tree.set("parameters/conditions/not_melee", !_target_in_melee_range())
	anim_tree.set("parameters/conditions/timer_run_out", active_shoot)
	anim_tree.set("parameters/conditions/timer_set", !active_shoot)
	anim_tree.set("parameters/conditions/hit_detected", hit_by_bullet)
	anim_tree.set("parameters/conditions/dead", is_dead)
	
	if health <= 0:
		is_dead = true

	#print(hit_by_bullet)
	move_and_slide()

func _target_in_melee_range():
	return global_position.distance_to(player.global_position) < attack_range

func chase():
	look_at(player.position)
	navigation_agent.target_position = player.global_position


func _on_area_3d_body_part_hit(damage: Variant) -> void:
	hit_by_bullet = true
	hit_stagger_timer.start(1.57)
	health -= damage
	print(health)
	


func _on_close_range_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		player_in_close_range = true
		player_in_long_range = true


func _on_long_range_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		player_in_long_range = true
		player_in_close_range = false


func _on_enemy_view_area_body_entered(body: Node3D) -> void:
	pass # Replace with function body.


func _on_close_range_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_close_range = false


func _on_long_range_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		player_in_long_range = false
		player_detected = false


func _on_shoot_trigger_timeout() -> void:
	active_shoot = true
	print("shoot triggered!")
	
	


func _on_hit_stagger_timeout() -> void:
	hit_by_bullet = false
