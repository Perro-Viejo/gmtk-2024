extends Hotspot


func _on_clicked() -> void:
	input_pickable = false
	get_parent().play(&"scared")
	await get_parent().animation_finished
	
	input_pickable = true
	get_parent().play(&"idle")
