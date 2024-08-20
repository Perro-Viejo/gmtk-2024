extends Node2D

@export var amb: AudioStreamOggVorbis = null
@export var transition: AudioStreamOggVorbis = null
@export var credits: AudioStreamOggVorbis = null
@export var turn_switch: AudioStreamOggVorbis = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var start_btn: Button = %StartBtn
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var credits_btn: Button = %CreditsBtn


func _ready() -> void:
	start_btn.pressed.connect(_start)
	AudioManager.play_sound(amb)
	
	credits_btn.pressed.connect(_show_credits)


func _start() -> void:
	animation_player.play("zoom_out")
	AudioManager.play_sound(transition)
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://screens/lab/lab.tscn")


func _show_credits() -> void:
	AudioManager.play_sound(turn_switch)
	if not $Credits.visible:
		$Credits.show()
		animation_player.play("Credits")
		#AudioManager.play_sound(credits)
	else:
		#AudioManager.stop_sound(credits)
		$Credits.hide()
