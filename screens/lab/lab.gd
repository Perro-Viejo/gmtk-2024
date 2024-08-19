extends Node2D

@export var world_1: AudioStreamOggVorbis = null
@export var world_2: AudioStreamOggVorbis = null
@export var world_3: AudioStreamOggVorbis = null
@export var alarm_start: AudioStreamOggVorbis = null
@export var alarm_loop: AudioStreamOggVorbis = null
@export var emergency_button_press: AudioStreamOggVorbis = null

var current_world := 1

@onready var tv: SubViewport = %TV
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var pianos: Node2D = %Pianos
@onready var keyboards: Node2D = %Keyboards
# ---- UI ------------------------------------------------------------------------------------------
@onready var failed_text: RichTextLabel = %FailedText
@onready var restart_btn: TextureButton = %RestartBtn


func _ready() -> void:
	#($TVScreen.texture as ViewportTexture).viewport_path = %TV.get_path()
	restart_btn.set_meta("hidden_y", restart_btn.position.y)
	
	for keyboard: Node2D in keyboards.get_children():
		keyboard.scale_achieved.connect(_on_scale_achieved)
		keyboard.scale_failed.connect(_on_scale_failed)
	
	restart_btn.pressed.connect(_restart)
	
	# Show the first world and its keyboard
	_start()


func _start() -> void:
	tv.hide_worlds()
	_start_keyboards()
	
	# TODO: Play a tween?
	tv.start()
	
	_show_keyboard()


func _start_keyboards() -> void:
	for keyboard: Node2D in keyboards.get_children():
		keyboard.position.y = keyboard.hidden_y
	
	for piano: Node2D in pianos.get_children():
		piano.position.y = piano.hidden_y


func _on_scale_achieved() -> void:
	var prev_world: Sprite2D = tv.worlds.get_child(current_world - 1)
	current_world += 1
	var next_world: Sprite2D = tv.worlds.get_child(current_world - 1)
	audio_stream_player.stream = self["world_%d" % (current_world - 1)]
	audio_stream_player.play()
	
	var worlds_tween := create_tween()
	worlds_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel(true)
	worlds_tween.tween_property(prev_world, "modulate:a", 0.0, 12.0)
	worlds_tween.tween_property(next_world, "modulate:a", 1.0, 12.0).set_delay(3.0)
	await audio_stream_player.finished
	
	if current_world == 4:
		return
	
	_hide_keyboard()
	await get_tree().create_timer(2.0).timeout
	
	_show_keyboard()


func _on_scale_failed() -> void:
	_hide_keyboard()
	failed_text.show()
	AudioManager.play_sound(alarm_start)
	await get_tree().create_timer(3.0).timeout
	AudioManager.play_sound(alarm_loop, name)
	restart_btn.disabled = false
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		restart_btn, "position:y", restart_btn.get_meta("hidden_y") + 256, 0.5
	).from_current()


func _restart() -> void:
	AudioManager.play_sound(emergency_button_press)
	AudioManager.stop_sound(alarm_loop, name)
	restart_btn.disabled = true
	failed_text.hide()
	current_world = 1
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		restart_btn, "position:y", restart_btn.get_meta("hidden_y"), 0.5
	).from_current()
	
	_start()


func _hide_keyboard() -> void:
	var piano := pianos.get_child(current_world - 2)
	var keyboard := keyboards.get_child(current_world - 2)
	var keyboard_tween := create_tween()
	keyboard_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_parallel()
	keyboard_tween.tween_property(piano, "position:y", piano.hidden_y, 1.0)
	keyboard_tween.tween_property(keyboard, "position:y", keyboard.hidden_y, 0.8)


func _show_keyboard() -> void:
	var piano := pianos.get_child(current_world - 1)
	var keyboard := keyboards.get_child(current_world - 1)
	var keyboard_tween := create_tween()
	keyboard_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel()
	keyboard_tween.tween_property(piano, "position:y", piano.visible_y, 1.6)
	keyboard_tween.tween_property(keyboard, "position:y", keyboard.visible_y, 1.6)
