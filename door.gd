# Door.gd
extends Area3D

func _ready():
	# Connect the signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Only react if the entering body is the player
	if body.is_in_group("player"):
		# Teleport to a random scene, excluding the current one
		GameManager.teleport_to_random_scene(GameManager.current_scene_name)
