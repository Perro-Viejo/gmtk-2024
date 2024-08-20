@tool
extends Node2D

@export var amb: AudioStreamOggVorbis = null
@export var transition: AudioStreamOggVorbis = null
@export var credits: AudioStreamOggVorbis = null
@export var turn_switch: AudioStreamOggVorbis = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var start_btn: Button = %StartBtn
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var credits_btn: Button = %CreditsBtn
@onready var tv: SubViewport = $TV


func _ready() -> void:
	if ($TVScreen.texture as ViewportTexture).viewport_path != NodePath("TV"):
		($TVScreen.texture as ViewportTexture).viewport_path = NodePath("TV")
	
	if Engine.is_editor_hint():
		return
	
	tv.show_empty_world()
	start_btn.pressed.connect(_start)
	AudioManager.play_sound(amb)
	
	credits_btn.pressed.connect(_show_credits)


func _start() -> void:
	tv.set_static(true)
	animation_player.play("zoom_out")
	AudioManager.play_sound(transition)
	$Overlay/TvSwitch.flip_v = true
	start_btn.pressed.disconnect(_start)
	await animation_player.animation_finished
	
	tv.set_static(false)
	$Overlay/TvSwitch.flip_v = false
	get_tree().change_scene_to_file("res://screens/lab/lab.tscn")


func _show_credits() -> void:
	if $Overlay/TvKnob.flip_h == true:
		$Overlay/TvKnob.flip_h = false
	else:
		$Overlay/TvKnob.flip_h = true
	AudioManager.play_sound(turn_switch)
	tv.play_credits()
