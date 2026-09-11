extends Node3D

@onready var enemy_ui: CanvasLayer = $EnemyUI
@onready var health_bar: ProgressBar = $EnemyUI/HealthBar

# ---------- STAGE COMPLETE UI ----------
@onready var stage_complete_ui: CanvasLayer = $StageCompleteUI
@onready var play_again_button: Button = $StageCompleteUI/CenterContainer/VBoxContainer/PlayAgainButton
@onready var main_menu_button: Button = $StageCompleteUI/CenterContainer/VBoxContainer/MainMenuButton
# --------------------------------------

# ---------- PAUSE MENU ----------
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var resume_button: Button = $PauseMenu/CenterContainer/VBoxContainer/ResumeButton
@onready var exit_button: Button = $PauseMenu/CenterContainer/VBoxContainer/ExitButton
# --------------------------------

var enemy: Node3D

func _ready():
	# Find the enemy
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() > 0:
		enemy = enemies[0]
		health_bar.max_value = enemy.health
		health_bar.value = enemy.health
		enemy.health_changed.connect(_on_enemy_health_changed)
		enemy.tree_exited.connect(_on_enemy_destroyed)
		enemy.enemy_died.connect(_on_enemy_died)
	else:
		enemy_ui.visible = false
		stage_complete_ui.visible = false
	
	# ---------- SETUP STAGE COMPLETE MENU ----------
	stage_complete_ui.visible = false
	play_again_button.pressed.connect(_on_play_again_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	# ----------------------------------------------
	
	# ---------- SETUP PAUSE MENU ----------
	pause_menu.visible = false
	resume_button.pressed.connect(_on_resume_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	# --------------------------------------

func _on_enemy_health_changed(new_health: int):
	health_bar.value = new_health

func _on_enemy_destroyed():
	enemy_ui.visible = false

# ---------- STAGE COMPLETE FUNCTIONS ----------
func _on_enemy_died():
	stage_complete_ui.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_play_again_pressed():
	GameManager.player_health = 100
	GameManager.current_scene_name = "bathroom"
	get_tree().change_scene_to_file("res://bathroom.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
# ----------------------------------------------

# ---------- PAUSE MENU FUNCTIONS ----------
func _on_resume_pressed():
	get_tree().paused = false
	pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_exit_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	get_tree().change_scene_to_file("res://main_menu.tscn")
# ------------------------------------------
