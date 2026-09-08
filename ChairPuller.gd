# ChairPuller.gd
extends Node3D

## How far the chair slides out (in meters)
@export var pull_distance: float = 0.8

## Direction the chair slides (use the 3D gizmo to find the right axis)
@export var pull_direction: Vector3 = Vector3.BACK

## Time the slide takes (in seconds)
@export var pull_speed: float = 1.5

@onready var trigger_area: Area3D = $TriggerArea

var has_pulled: bool = false
var start_position: Vector3

func _ready():
	start_position = global_position
	if trigger_area:
		trigger_area.body_entered.connect(_on_trigger_entered)
	else:
		push_error("ChairPuller: No child Area3D named 'TriggerArea' found!")

func _on_trigger_entered(body):
	if has_pulled:
		return
	# Only react to the player (must be in group "player")
	if body.is_in_group("player"):
		pull_chair()

func pull_chair():
	has_pulled = true
	# Disable the trigger so it doesn't fire again
	trigger_area.monitoring = false

	var target_position = start_position + pull_direction.normalized() * pull_distance

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", target_position, pull_speed)
