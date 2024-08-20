extends Area2D
class_name Hotspot

signal clicked


func _ready() -> void:
	input_event.connect(_on_input_event)
	mouse_entered.connect(
		func () -> void:
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	)
	mouse_exited.connect(
		func () -> void:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		_on_clicked()


func _on_clicked() -> void:
	clicked.emit()
