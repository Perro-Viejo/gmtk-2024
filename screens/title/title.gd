extends Node2D

@export var amb: AudioStreamOggVorbis = null
@export var transition: AudioStreamOggVorbis = null
@export var credits: AudioStreamOggVorbis = null

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
	if not $Credits.visible:
		$Credits.show()
		AudioManager.play_sound(credits)
	else:
		AudioManager.stop_sound(credits)
		$Credits.hide()
