# GameManager.gd
extends Node

# List of all scene names (must match the .tscn filenames)
const SCENES = ["main", "bathroom", "bedroom"]

# Name of the currently active scene (set when changing)
var current_scene_name: String = "main"

#player health
var player_health: int = 100:
	set(value):
		# Clamp between 0 and 100
		player_health = clampi(value, 0, 100)
		# Emit a signal so the UI updates automatically
		health_changed.emit(player_health)

signal health_changed(new_health)

#call this when the player takes damage
func take_damage(amount: int):
	player_health -= amount

#call this when the player heals
func heal(amount: int):
	player_health += amount
	
# Called when a new scene becomes active (from the scene's _ready)
func initialize_player():
	var tree = get_tree()
	# Find the player (must be in group "player")
	var player = tree.get_first_node_in_group("player")
	if not player:
		push_warning("No player found in group 'player'")
		return
	
	# Find a spawn point (must be in group "spawn_points")
	var spawn_points = tree.get_nodes_in_group("spawn_points")
	if spawn_points.is_empty():
		push_warning("No spawn point found in group 'spawn_points'")
		return
	
	# Pick a random spawn point (or just use the first one)
	var spawn = spawn_points[randi() % spawn_points.size()]
	player.global_position = spawn.global_position
	
	# Reset velocity if the player has a method for it
	if player.has_method("set_velocity"):
		player.set_velocity(Vector3.ZERO)

# Teleport to a random scene, excluding the given one
func teleport_to_random_scene(exclude: String):
	var available = SCENES.duplicate()
	available.erase(exclude)
	if available.is_empty():
		return
	
	var target = available[randi() % available.size()]
	current_scene_name = target
	var scene_path = "res://" + target + ".tscn"
	
	print("Teleporting to: ", target)  # Debug

	# 🔥 CRITICAL: The 'await' keywords MUST be here!
	await TransitionManager.fade_out(0.5)
	
	get_tree().change_scene_to_file(scene_path)
	
	await TransitionManager.fade_in(0.5)
	print("Teleport complete.")
	
	
