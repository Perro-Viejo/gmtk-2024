extends Node2D

signal pressed(order: int)

@export var note: AudioStreamOggVorbis = null
@export var order := 1

@onready var area_2d: Area2D = $Area2D
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer


func _ready() -> void:
	area_2d.input_event.connect(_on_input_event)
	area_2d.mouse_entered.connect(
		func () -> void:
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	)
	area_2d.mouse_exited.connect(
		func () -> void:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		if note:
			audio_stream_player.stream = note
			audio_stream_player.play()
		pressed.emit(order)
