extends Control

const game_scene: String = "res://assets/game_screen/GameScene.tscn"
const scores_pattern: String = "Your best scores: %s"

onready var AnimPlayer = $Camera2D/AnimationPlayer
onready var music_check = $HBoxContainer/VBoxContainer2/MusicContainer/HBoxContainer/MusicCheck
onready var sound_check = $HBoxContainer/VBoxContainer2/SoundsContainer/HBoxContainer/SoundsCheck
onready var scores_text = $HBoxContainer/VBoxContainer/ScoresBox/ScoresText
onready var scores_box = $HBoxContainer/VBoxContainer/ScoresBox


func _ready():
	music_check.pressed = Setting.get_setting("audio", "music")
	sound_check.pressed = Setting.get_setting("audio", "sounds")
	var best_scores: int = Setting.get_setting("player", "best_scores")
	if best_scores != 0:
		scores_text.text = scores_pattern % [best_scores]
	else:
		scores_box.visible = false


func _on_play_pressed():
	get_tree().change_scene(game_scene)
	queue_free()


func _on_settings_pressed():
	get_tree().get_root().set_disable_input(true)
	AnimPlayer.play("to_settings")
	
	yield(AnimPlayer, "animation_finished")
	get_tree().get_root().set_disable_input(false)


func _on_back_pressed():
	get_tree().get_root().set_disable_input(true)
	AnimPlayer.play_backwards("to_settings")
	
	yield(AnimPlayer, "animation_finished")
	get_tree().get_root().set_disable_input(false)


func _on_music_toggled(button_pressed):
	Setting.set_setting("audio", "music", button_pressed)
	Setting.save_settings()
	MusicPlayer.update_volumes()


func _on_sounds_toggled(button_pressed):
	Setting.set_setting("audio", "sounds", button_pressed)
	Setting.save_settings()
	MusicPlayer.update_volumes()
