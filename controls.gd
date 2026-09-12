extends Control

@onready var play_button: Button = $VBoxContainer/Continue


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)

	
	play_button.grab_focus()  # keyboard/gamepad friendly

func _on_play_pressed() -> void:
	# Change to your gameplay scene
	get_tree().change_scene_to_file("res://main_menu.tscn")
