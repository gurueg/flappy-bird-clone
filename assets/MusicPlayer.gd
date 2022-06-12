extends AudioStreamPlayer


var audioFiles = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	audioFiles.die = preload("res://assets/audio/die.ogg")
	audioFiles.hit = preload("res://assets/audio/hit.ogg")
	audioFiles.swoosh = preload("res://assets/audio/swoosh.ogg")


func play_sound(sound_name: String):
	if audioFiles.has(sound_name):
		var audioPlayer = AudioStreamPlayer.new()
		audioPlayer.stream = audioFiles[sound_name]
		add_child(audioPlayer)
		audioPlayer.play()
		
		yield(audioPlayer, "finished")
		remove_child(audioPlayer)
		
