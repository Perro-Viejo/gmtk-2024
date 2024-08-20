extends Node2D

signal pressed(order: int)

@export var note: AudioStreamOggVorbis = null
@export var order := 1

@onready var area_2d: Area2D = $Area2D
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer


func _ready() -> void:
	area_2d.clicked.connect(_on_clicked)


func _on_clicked() -> void:
	disable()
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", position.y + 6, 0.1)
	tween.tween_property(self, "position:y", position.y, 0.05).set_ease(Tween.EASE_IN)
	audio_stream_player.stream = note
	audio_stream_player.play()
	pressed.emit(order)
	await tween.finished
	
	enable()


func disable() -> void:
	area_2d.input_pickable = false


func enable() -> void:
	area_2d.input_pickable = true
