extends SubViewport

@onready var worlds: Node2D = $Worlds

func start() -> void:
	# TODO: Play a tween?
	worlds.get_child(0).modulate.a = 1.0


func hide_worlds() -> void:
	for world: Sprite2D in worlds.get_children():
		world.modulate.a = 0.0
