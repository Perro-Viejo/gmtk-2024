extends Node2D

var available_streams: Array
var manager_streams: Array
var current_stream_player : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	manager_streams = self.get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func play_sound(stream: AudioStreamOggVorbis, ID: String = "") -> void:
	if stream != null:
		available_streams = manager_streams.filter(stream_is_available)
		current_stream_player = available_streams[0]
		current_stream_player.stream = stream
	else:
		print("AudioManager: Not a valid stream to play")
	current_stream_player.play()
	if ID != "":
		current_stream_player.name = current_stream_player.name + "_" + ID

func stop_sound (stream: AudioStreamOggVorbis, ID: String = "") -> void:
	if stream != null:
		manager_streams.filter(stream_is_playing)
		if ID != "":
			check_player_stream(stream, manager_streams.filter(stream_is_playing)).name = current_stream_player.name.replace("_" + ID, "")
		if check_player_stream(stream, manager_streams.filter(stream_is_playing)) != null:
			check_player_stream(stream, manager_streams.filter(stream_is_playing)).stop()
		
	else:
		print("AudioManager: Not a valid stream to stop")

func stream_is_available(stream: AudioStreamPlayer) -> bool:
	if stream.is_playing():
		return false
	else:
		return true

func stream_is_playing(player: AudioStreamPlayer) -> bool:
	return player.is_playing()

func check_player_stream(requested_stream: AudioStreamOggVorbis, players: Array):
	for i in players:
		if i.stream == requested_stream:
			return i
