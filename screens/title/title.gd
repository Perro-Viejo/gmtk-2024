extends Node2D

@export var amb: AudioStreamOggVorbis = null
@export var transition: AudioStreamOggVorbis = null
@export var nanai: AudioStreamOggVorbis = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var start_btn: Button = %StartBtn
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	
	start_btn.pressed.connect(_start)
	AudioManager.play_sound(amb)
	


func _start() -> void:
	animation_player.play("zoom_out")
	AudioManager.play_sound(transition)
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://screens/lab/lab.tscn")
