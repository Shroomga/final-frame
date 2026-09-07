# main.gd (similarly for bathroom.gd, bedroom.gd)
extends Node3D   # or whatever your root type is

func _ready():
	# This moves the player to the spawn point when the scene starts
	GameManager.initialize_player()
