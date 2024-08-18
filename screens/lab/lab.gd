extends Node2D

@export var world_1: AudioStreamMP3 = null
@export var world_2: AudioStreamMP3 = null
@export var world_3: AudioStreamMP3 = null

var current_world := 1

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var worlds: Node2D = $Worlds
@onready var keyboards: Node2D = %Keyboards
@onready var failed_text: RichTextLabel = %FailedText


func _ready() -> void:
	for world: Sprite2D in worlds.get_children():
		world.modulate.a = 0.0
	for keyboard: Node2D in keyboards.get_children():
		keyboard.scale_achieved.connect(_on_scale_achieved)
		keyboard.scale_failed.connect(_on_scale_failed)
	worlds.get_child(0).modulate.a = 1.0


func _on_scale_achieved() -> void:
	_hide_keyboard()
	
	var prev_world := worlds.get_child(current_world - 1)
	current_world += 1
	var next_world := worlds.get_child(current_world - 1)
	audio_stream_player.stream = self["world_%d" % (current_world - 1)]
	audio_stream_player.play()
	
	var worlds_tween := create_tween()
	worlds_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel(true)
	worlds_tween.tween_property(prev_world, "modulate:a", 0.0, 12.0)
	worlds_tween.tween_property(next_world, "modulate:a", 1.0, 12.0).set_delay(3.0)


func _on_scale_failed() -> void:
	_hide_keyboard()
	failed_text.show()
	await get_tree().create_timer(3.0).timeout
	
	failed_text.hide()
	_show_keyboard()


func _hide_keyboard() -> void:
	var keyboard := keyboards.get_child(current_world - 1)
	var keyboard_tween := create_tween()
	keyboard_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	keyboard_tween.tween_property(keyboard, "position:y", keyboard.position.y + 256, 0.6)


func _show_keyboard() -> void:
	var keyboard := keyboards.get_child(current_world - 1)
	var keyboard_tween := create_tween()
	keyboard_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	keyboard_tween.tween_property(keyboard, "position:y", keyboard.position.y - 256, 0.6)
