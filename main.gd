# main.gd (attach to the root Node3D of main.tscn)
extends Node3D

@onready var enemy_ui: CanvasLayer = $EnemyUI
@onready var health_bar: ProgressBar = $EnemyUI/HealthBar

var enemy: Node3D

func _ready():
	# Find the enemy (it should be in the "enemy" group)
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() > 0:
		enemy = enemies[0]
		# Set the bar's max to the enemy's max health (assuming 50)
		health_bar.max_value = enemy.health
		health_bar.value = enemy.health
		# Connect to the enemy's health signal
		enemy.health_changed.connect(_on_enemy_health_changed)
		# Hide the bar when the enemy is destroyed
		enemy.tree_exited.connect(_on_enemy_destroyed)
	else:
		# No enemy found – hide the UI
		enemy_ui.visible = false

func _on_enemy_health_changed(new_health: int):
	health_bar.value = new_health

func _on_enemy_destroyed():
	enemy_ui.visible = false
