extends Control

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var exit_button: Button = $VBoxContainer/ExitButton

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	
	play_button.grab_focus()  # keyboard/gamepad friendly

func _on_play_pressed() -> void:
	# Change to your gameplay scene
	get_tree().change_scene_to_file("res://story.tscn")

func _on_settings_pressed() -> void:
	# Open settings as overlay or new scene
	get_tree().change_scene_to_file("res://controls.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
