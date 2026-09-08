# TransitionManager.gd
extends CanvasLayer

var color_rect: ColorRect

func _ready():
	print("TransitionManager loaded!")
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	
	color_rect = ColorRect.new()
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	
	color_rect.color = Color.BLACK
	color_rect.modulate = Color(0, 0, 0, 0)  # <-- Explicitly set alpha to 0!
	
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(color_rect)
	layer = 10

func fade_out(duration: float = 0.5):
	print("Fading out...")
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate", Color(0, 0, 0, 1.0), duration)
	await tween.finished
	print("Fade out complete. Alpha: ", color_rect.modulate.a)

func fade_in(duration: float = 0.5):
	print("Fading in...")
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate", Color(0, 0, 0, 0.0), duration)
	await tween.finished
	print("Fade in complete. Alpha: ", color_rect.modulate.a)
