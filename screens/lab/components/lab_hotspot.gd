extends Hotspot

@export var sfx: AudioStreamOggVorbis = null


func _on_clicked() -> void:
	if sfx:
		AudioManager.play_sound(sfx, get_parent().name)
	# TODO: Play a Tween?
