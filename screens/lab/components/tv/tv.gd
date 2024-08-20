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


func start(world := 0) -> void:
	$CreditsScene.hide()
	$EmptyWorld.hide()
	$Worlds.show()
	# TODO: Play a tween?
	worlds.get_child(world).modulate.a = 1.0
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
		
		if OS.has_feature("web"):
			prints(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
			await get_tree().create_timer(0.1).timeout
			$CreditsScene/AudioStreamPlayer.stop()
		
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
	if $CreditsScene.visible:
		$CreditsScene/AudioStreamPlayer.stop()
		$CreditsScene/AnimationPlayer.stop()
		$CreditsScene.hide()
		$EmptyWorld.show()
	else:
		$CreditsScene.show()
		$EmptyWorld.hide()
		$CreditsScene/AudioStreamPlayer.play()
		$CreditsScene/AnimationPlayer.play("Credits")
