# main.gd (similarly for bathroom.gd, bedroom.gd)
extends Node3D   # or whatever your root type is
# ---------- PAUSE MENU ----------
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var resume_button: Button = $PauseMenu/CenterContainer/VBoxContainer/ResumeButton
@onready var exit_button: Button = $PauseMenu/CenterContainer/VBoxContainer/ExitButton
func _ready():
	# This moves the player to the spawn point when the scene starts
	GameManager.initialize_player()
	
# ---------- SETUP PAUSE MENU ----------
	pause_menu.visible = false
	resume_button.pressed.connect(_on_resume_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	# --------------------------------------
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
