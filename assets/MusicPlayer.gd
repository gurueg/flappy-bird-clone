extends AudioStreamPlayer


var audioFiles = {}


func _ready():
	audioFiles.die = preload("res://assets/audio/die.ogg")
	audioFiles.hit = preload("res://assets/audio/hit.ogg")
	audioFiles.wing = preload("res://assets/audio/wing.ogg")
	audioFiles.point = preload("res://assets/audio/point.ogg")
	
	update_volumes()


func play_sound(sound_name: String):
	if audioFiles.has(sound_name):
		var audioPlayer = AudioStreamPlayer.new()
		audioPlayer.stream = audioFiles[sound_name]
		audioPlayer.bus = "SoundBus"
		add_child(audioPlayer)
		audioPlayer.play()
		
		yield(audioPlayer, "finished")
		remove_child(audioPlayer)
		
func update_volumes():
	var sounds_on = Setting.get_setting("audio", "sounds")
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundBus"), not sounds_on)
	var music_on = Setting.get_setting("audio", "music")
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), not music_on)
