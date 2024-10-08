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
	
	if _pressed_keys.length() == keys_order.length():
		await get_tree().create_timer(0.2).timeout
		
		disable()
		# Check if the scale is the correct one
		if _pressed_keys == keys_order:
			scale_achieved.emit()
		else:
			scale_failed.emit()
		_pressed_keys = ""


func disable() -> void:
	for key: Sprite2D in keys.get_children():
		key.disable()


func enable() -> void:
	for key: Sprite2D in keys.get_children():
		key.enable()
