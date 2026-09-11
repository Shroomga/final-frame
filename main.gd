# main.gd (attach to the root Node3D of main.tscn)
extends Node3D

@onready var enemy_ui: CanvasLayer = $EnemyUI
@onready var health_bar: ProgressBar = $EnemyUI/HealthBar

# ---------- STAGE COMPLETE UI ----------
@onready var stage_complete_ui: CanvasLayer = $StageCompleteUI
@onready var play_again_button: Button = $StageCompleteUI/CenterContainer/VBoxContainer/PlayAgainButton
@onready var main_menu_button: Button = $StageCompleteUI/CenterContainer/VBoxContainer/MainMenuButton
# --------------------------------------

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
		# ---------- CONNECT ENEMY DEATH SIGNAL ----------
		# The enemy emits this signal right before being freed
		enemy.enemy_died.connect(_on_enemy_died)
		# ------------------------------------------------
	else:
		# No enemy found – hide the UI
		enemy_ui.visible = false
		# Also hide the stage complete menu if there's no enemy
		stage_complete_ui.visible = false
	
	# ---------- SETUP STAGE COMPLETE MENU ----------
	# Hide menu at start
	stage_complete_ui.visible = false
	# Connect button signals
	play_again_button.pressed.connect(_on_play_again_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	# ----------------------------------------------

func _on_enemy_health_changed(new_health: int):
	health_bar.value = new_health

func _on_enemy_destroyed():
	enemy_ui.visible = false

# ---------- STAGE COMPLETE FUNCTIONS ----------
func _on_enemy_died():

	# Show the menu instantly
	stage_complete_ui.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_play_again_pressed():
	# Reload the main scene
	GameManager.player_health = 100   # reset health
	GameManager.current_scene_name = "bathroom"
	get_tree().change_scene_to_file("res://bathroom.tscn")

func _on_main_menu_pressed():
	# Change this to your actual main menu scene path
	get_tree().change_scene_to_file("res://main_menu.tscn")
# ----------------------------------------------
