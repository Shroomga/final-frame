extends Area3D

@export var flash_image: TextureRect
@export var flash_duration: float = 0.15   # how long the image stays visible
@export var gap_duration: float = 0.1      # pause between the two flashes
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
var has_triggered: bool = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if has_triggered:
		return
	if body.is_in_group("player"):
		has_triggered = true
		_flash_twice()

func _flash_twice():
	if not flash_image:
		return
	# Play the sound once at the start of the sequence
	if audio_player:
		audio_player.play()
	
	for i in range(2):
		flash_image.visible = true
		await get_tree().create_timer(flash_duration).timeout
		flash_image.visible = false
		
		# Only wait between the two flashes, not after the last one
		if i == 0:
			await get_tree().create_timer(gap_duration).timeout
