extends Hotspot

@export var sfx: AudioStreamRandomizer = null
@export var loops := 3
@export var x_offset := 4
@export var shake_step_time := 0.03

var tween: Tween = null

@onready var _position: Vector2 = get_parent().position

func _on_clicked() -> void:
	if tween and tween.is_running():
		return
	
	if sfx:
		AudioManager.play_sound(sfx.get_stream(randi_range(0, sfx.streams_count - 1)), get_parent().name)
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_loops(loops)
	tween.tween_property(get_parent(), "position:x", _position.x - x_offset, shake_step_time)
	tween.tween_property(get_parent(), "position:x", _position.x + x_offset, shake_step_time)
	tween.tween_property(get_parent(), "position:x", _position.x, shake_step_time)
