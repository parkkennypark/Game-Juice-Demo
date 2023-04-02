extends Node

enum Type {
	NON_POSITIONAL,
	POSITIONAL,
}


func play(type: int, parent: Node, stream: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0, bus: String = "Sound",) -> void:
	if !parent.is_inside_tree():
		return
	
	var audio_stream_player: Node
	match type:
		Type.NON_POSITIONAL:
			audio_stream_player = AudioStreamPlayer.new()
			parent.add_child(audio_stream_player)
		Type.POSITIONAL:
			audio_stream_player = AudioStreamPlayer3D.new()
			parent.add_child(audio_stream_player)
			audio_stream_player.global_position = parent.global_position

	
	if type == Type.NON_POSITIONAL:
		audio_stream_player.volume_db = volume_db
	else:
		audio_stream_player.volume_db = volume_db
		audio_stream_player.global_position = parent.global_position

	audio_stream_player.bus = bus
	audio_stream_player.stream = stream
	
	audio_stream_player.pitch_scale = pitch_scale
	audio_stream_player.play()
#	audio_stream_player.connect("finished",Callable(audio_stream_player,"queue_free"))
