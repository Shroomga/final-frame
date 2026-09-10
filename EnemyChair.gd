# EnemyChair.gd
extends CharacterBody3D
signal health_changed(new_health) 
@export var move_speed: float = 4.5
@export var damage_amount: int = 10
@export var attack_cooldown: float = 1.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var detection_area: Area3D = $DetectionArea
@onready var damage_area: Area3D = $DamageArea

var health: int = 50:
	set(value):
		health = value
		health_changed.emit(health) 
var is_chasing: bool = false
var player_in_damage_area: bool = false

# Timer that repeats while the player is in the damage area
var attack_timer: Timer

func _ready():
	detection_area.body_entered.connect(_on_detection_entered)
	detection_area.body_exited.connect(_on_detection_exited)
	damage_area.body_entered.connect(_on_damage_body_entered)
	damage_area.body_exited.connect(_on_damage_body_exited)
	nav_agent.target_position = global_position
	
	# Create the attack timer in code (repeating)
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = false   # repeat forever
	attack_timer.autostart = false
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

func _physics_process(delta):
	if not is_chasing:
		return
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		nav_agent.target_position = player.global_position
	
	if nav_agent.is_navigation_finished():
		return
	
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()

func _on_detection_entered(body):
	if body.is_in_group("player"):
		is_chasing = true

func _on_detection_exited(body):
	if body.is_in_group("player"):
		is_chasing = false
		nav_agent.target_position = global_position

# Player enters the damage area – start attacking on a loop
func _on_damage_body_entered(body):
	if body.is_in_group("player"):
		player_in_damage_area = true
		# Immediately attack once, then the timer keeps firing
		_attack_player()
		attack_timer.start()

# Player leaves the damage area – stop attacking
func _on_damage_body_exited(body):
	if body.is_in_group("player"):
		player_in_damage_area = false
		attack_timer.stop()

# Called every attack_cooldown seconds while the player is inside the damage area
func _on_attack_timer_timeout():
	if player_in_damage_area:
		_attack_player()

# Deals damage to the player
func _attack_player():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.take_damage(damage_amount)

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		queue_free()
