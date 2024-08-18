extends Node2D

signal pressed(order: int)

@export var note: AudioStreamOggVorbis = null
@export var order := 1

@onready var area_2d: Area2D = $Area2D
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer


func _ready() -> void:
	area_2d.input_event.connect(_on_input_event)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		audio_stream_player.stream = note
		audio_stream_player.play()
		pressed.emit(order)
