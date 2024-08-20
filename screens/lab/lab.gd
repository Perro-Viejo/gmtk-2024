@tool
extends Node2D

@export var world_1: AudioStreamOggVorbis = null
@export var world_2: AudioStreamOggVorbis = null
@export var world_3: AudioStreamOggVorbis = null
@export var alarm_start: AudioStreamOggVorbis = null
@export var alarm_loop: AudioStreamOggVorbis = null
@export var emergency_button_press: AudioStreamOggVorbis = null

var current_world := 1

@onready var tv: SubViewport = $TV
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var pianos: Node2D = %Pianos
@onready var keyboards: Node2D = %Keyboards
@onready var bulb: AnimatedSprite2D = %Bulb
@onready var left_door: Sprite2D = %LeftDoor
@onready var right_door: Sprite2D = %RightDoor
@onready var animation_player: AnimationPlayer = $AnimationPlayer
# ---- UI ------------------------------------------------------------------------------------------
@onready var failed_text: RichTextLabel = %FailedText
@onready var restart_btn: TextureButton = %RestartBtn


func _ready() -> void:
	if ($TVScreen.texture as ViewportTexture).viewport_path != NodePath("TV"):
		($TVScreen.texture as ViewportTexture).viewport_path = NodePath("TV")
	
	if Engine.is_editor_hint():
		return
	
	restart_btn.scale = Vector2.ZERO
	restart_btn.set_meta("hidden_y", restart_btn.position.y)
	bulb.set_meta("hidden_y", bulb.position.y)
	
	for keyboard: Node2D in keyboards.get_children():
		keyboard.scale_achieved.connect(_on_scale_achieved)
		keyboard.scale_failed.connect(_on_scale_failed)
	
	restart_btn.pressed.connect(_restart)
	
	# Show the first world and its keyboard
	_start()


func _start() -> void:
	animation_player.play("RESET")
	tv.hide_worlds()
	_start_keyboards()
	tv.start(current_world - 1)
	
	keyboards.get_child(current_world - 1).enable()
	keyboards.get_child(current_world - 1).position.y = keyboards.get_child(0).visible_y
	pianos.get_child(current_world - 1).position.y = pianos.get_child(0).visible_y


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
	
	if current_world == 4:
		animation_player.play("ending")
	
	await audio_stream_player.finished
	
	if current_world == 4:
		return
	
	_hide_keyboard()
	await get_tree().create_timer(2.0).timeout
	
	_show_keyboard()


func _on_scale_failed() -> void:
	tv.set_static(true)
	AudioManager.play_sound(alarm_start)
	await get_tree().create_timer(3.0).timeout
	
	AudioManager.play_sound(alarm_loop, name)
	var bulb_tween := create_tween()
	bulb_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	bulb_tween.tween_property(bulb, "position:y", 148, 1.0)
	
	restart_btn.disabled = false
	var restart_btn_tween := create_tween()
	restart_btn_tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	restart_btn_tween.tween_property(restart_btn, "scale", Vector2.ONE, 1.0).from(Vector2.ZERO)
	
	$OldMan.sprite_frames.set_animation_loop(&"scared", true)
	$OldMan.play(&"scared")


func _restart() -> void:
	$OldMan.sprite_frames.set_animation_loop(&"scared", false)
	$OldMan.play(&"idle")
	AudioManager.play_sound(emergency_button_press)
	AudioManager.stop_sound(alarm_loop, name)
	tv.set_static(false)
	restart_btn.disabled = true
	#current_world -= 1
	
	var bulb_tween := create_tween()
	bulb_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	bulb_tween.tween_property(bulb, "position:y", -178, 0.5)
	
	var restart_btn_tween := create_tween()
	restart_btn_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	restart_btn_tween.tween_property(restart_btn, "scale", Vector2.ZERO, 0.3).from(Vector2.ONE)
	
	_start()


func _hide_keyboard() -> void:
	# Open the door
	var door_tween := create_tween()
	door_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_parallel()
	door_tween.tween_property(left_door, "position:x", -85, 0.8)
	door_tween.tween_property(right_door, "position:x", 132, 0.8)
	await door_tween.finished
	
	# Hide the piano and the keyboard
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
	await keyboard_tween.finished
	
	# Close the door
	var door_tween := create_tween()
	door_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_parallel()
	door_tween.tween_property(left_door, "position:x", 0, 0.8)
	door_tween.tween_property(right_door, "position:x", 0, 0.8)
	await door_tween.finished
