extends Node2D

signal scale_achieved
signal scale_failed

@export var keys_order := ""

var _pressed_keys := ""

@onready var keys: Node2D = $Keys


func _ready() -> void:
	for key: Sprite2D in keys.get_children():
		key.pressed.connect(_on_key_pressed)


func _on_key_pressed(order: int) -> void:
	_pressed_keys += str(order)
	
	if _pressed_keys.length() == keys_order.length():
		# Check if the scale is the correct one
		if _pressed_keys == keys_order:
			scale_achieved.emit()
		else:
			scale_failed.emit()
		_pressed_keys = ""
