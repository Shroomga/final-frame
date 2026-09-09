# EnemyChair.gd
extends CharacterBody3D

@export var move_speed: float = 5.5
@export var damage_amount: int = 10
@export var attack_cooldown: float = 1.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var detection_area: Area3D = $DetectionArea
@onready var damage_area: Area3D = $DamageArea

var health: int = 50
var is_chasing: bool = false
var can_attack: bool = true

func _ready():
	detection_area.body_entered.connect(_on_detection_entered)
	detection_area.body_exited.connect(_on_detection_exited)
	damage_area.body_entered.connect(_on_damage_body_entered)
	nav_agent.target_position = global_position

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

func _on_damage_body_entered(body):
	if body.is_in_group("player") and can_attack:
		body.take_damage(damage_amount)
		can_attack = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		queue_free()
