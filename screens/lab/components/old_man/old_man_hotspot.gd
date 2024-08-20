extends Hotspot

@export var sfx: AudioStreamRandomizer = null

func _on_clicked() -> void:
	if get_parent().is_playing() and get_parent().animation == &"scared":
		return
	
	input_pickable = false
	get_parent().play(&"scared")
	if sfx:
		AudioManager.play_sound(sfx.get_stream(randi_range(0, sfx.streams_count -1)), get_parent().name)
	await get_parent().animation_finished
	
	input_pickable = true
	get_parent().play(&"idle")
	
	
