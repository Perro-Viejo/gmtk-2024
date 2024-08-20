extends SubViewport

@export var tv_idle: AudioStreamOggVorbis = null
@export var tv_static: AudioStreamOggVorbis = null
@export var tv_on: AudioStreamOggVorbis = null
@export var tv_off: AudioStreamOggVorbis = null

@onready var worlds: Node2D = $Worlds


func _ready() -> void:
	$CreditsScene.hide()
	$EmptyWorld.hide()
	$Worlds.hide()


func start() -> void:
	$CreditsScene.hide()
	$EmptyWorld.hide()
	$Worlds.show()
	# TODO: Play a tween?
	worlds.get_child(0).modulate.a = 1.0
	AudioManager.play_sound(tv_idle)


func hide_worlds() -> void:
	for world: Sprite2D in worlds.get_children():
		world.modulate.a = 0.0


func set_static(show: bool) -> void:
	if show == true:
		AudioManager.stop_sound(tv_idle)
		AudioManager.play_sound(tv_static)
		AudioManager.play_sound(tv_off)
		$Worlds.hide()
		$CreditsScene/AnimationPlayer.stop()
		$CreditsScene.hide()
		$EmptyWorld.hide()
		$PostProcessingStack.find_child("Noise").show()
	else:
		AudioManager.stop_sound(tv_static)
		#AudioManager.play_sound(tv_idle)
		#Depronto no se necesita por el Ready
		AudioManager.play_sound(tv_on)
		$Worlds.show()
		$PostProcessingStack.find_child("Noise").hide()


func show_empty_world() -> void:
	$EmptyWorld.show()


func play_credits() -> void:
	if $CreditsScene/AnimationPlayer.is_playing():
		$CreditsScene/AnimationPlayer.stop()
		$CreditsScene.hide()
		$EmptyWorld.show()
	else:
		$CreditsScene.show()
		$EmptyWorld.hide()
		$CreditsScene/AnimationPlayer.play("Credits")
