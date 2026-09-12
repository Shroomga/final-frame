# EnemyChair.gd
extends CharacterBody3D

signal health_changed(new_health) 
signal enemy_died

@export var move_speed: float = 4.5
@export var damage_amount: int = 10
@export var attack_cooldown: float = 2.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var detection_area: Area3D = $DetectionArea
@onready var damage_area: Area3D = $DamageArea
@onready var animation_player: AnimationPlayer = $Model/diningChair/AnimationPlayer
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var attack_sound: AudioStreamPlayer3D = $AttackSound
@onready var hurt_sound: AudioStreamPlayer3D = $HurtSound
@onready var death_sound: AudioStreamPlayer3D = $DeathSound

var health: int = 50:
	set(value):
		health = value
		health_changed.emit(health) 

var is_chasing: bool = false
var player_in_damage_area: bool = false
var is_dead: bool = false

var attack_timer: Timer

func _ready():
	detection_area.body_entered.connect(_on_detection_entered)
	detection_area.body_exited.connect(_on_detection_exited)
	damage_area.body_entered.connect(_on_damage_body_entered)
	damage_area.body_exited.connect(_on_damage_body_exited)
	nav_agent.target_position = global_position
	
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = false
	attack_timer.autostart = false
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)
	
	if animation_player:
		animation_player.play("Armature|spider_walk_fast_3")

func _physics_process(delta):
	if is_dead:
		return
	
	if not is_chasing:
		if animation_player and animation_player.current_animation == "Armature|spider_walk_fast_3":
			animation_player.stop()
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
	
	if animation_player and animation_player.current_animation != "Armature|spider_walk_fast_3":
		animation_player.play("Armature|spider_walk_fast_3")

func _on_detection_entered(body):
	if body.is_in_group("player"):
		is_chasing = true

func _on_detection_exited(body):
	if body.is_in_group("player"):
		is_chasing = false
		nav_agent.target_position = global_position

func _on_damage_body_entered(body):
	if body.is_in_group("player"):
		player_in_damage_area = true
		_attack_player()
		attack_timer.start()

func _on_damage_body_exited(body):
	if body.is_in_group("player"):
		player_in_damage_area = false
		attack_timer.stop()

func _on_attack_timer_timeout():
	if player_in_damage_area:
		_attack_player()

func _attack_player():
	if is_dead:
		return
	
	if attack_sound:
		attack_sound.play()
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.take_damage(damage_amount)

func take_damage(amount: int):
	if is_dead:
		return
	
	health -= amount
	
	if health <= 0:
		_die()
	else:
		if hurt_sound:
			hurt_sound.pitch_scale = randf_range(0.9, 1.1)
			hurt_sound.play()
		
		if animation_player:
			animation_player.play("Armature|spider_walk_slow")
			await animation_player.animation_finished
			if is_dead:
				return
			if is_chasing:
				animation_player.play("Armature|spider_walk_fast_3")

func _die():
	is_dead = true
	is_chasing = false
	player_in_damage_area = false
	attack_timer.stop()
	velocity = Vector3.ZERO
	
	# Stop looping sounds immediately
	if audio_player:
		audio_player.stop()
	if attack_sound:
		attack_sound.stop()
	if hurt_sound:
		hurt_sound.stop()
	
	# Play the death sound
	if death_sound:
		death_sound.play()
	
	if animation_player:
		animation_player.play("Armature|spider_dead")
		await animation_player.animation_finished
	
	enemy_died.emit()
	queue_free()
