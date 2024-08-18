extends Node2D

signal scale_achieved
signal scale_failed

@export var keys_order := ""
@export var visible_y := 0.0
@export var hidden_y := 0.0

var _pressed_keys := ""

@onready var keys: Node2D = $Keys
@onready var impact_player: AudioStreamPlayer = $ImpactPlayer


func _ready() -> void:
	for key: Sprite2D in keys.get_children():
		key.pressed.connect(_on_key_pressed)


func _on_key_pressed(order: int) -> void:
	impact_player.play()
	_pressed_keys += str(order)
	
	prints("_pressed_keys", _pressed_keys)
	if _pressed_keys.length() == keys_order.length():
		# Check if the scale is the correct one
		if _pressed_keys == keys_order:
			scale_achieved.emit()
		else:
			scale_failed.emit()
		_pressed_keys = ""
