extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var start_btn: Button = %StartBtn


func _ready() -> void:
	start_btn.pressed.connect(_start)


func _start() -> void:
	animation_player.play("zoom_out")
	await animation_player.animation_finished
	
	get_tree().change_scene_to_file("res://screens/lab/lab.tscn")
