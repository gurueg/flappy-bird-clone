extends Control

enum InterfaceStates {COUNTDOWN = 0, POINTS = 1, LOSE = 2, PAUSE = 3}

const best_scores_pattern = "Your best scores: %s"
const last_scores_pattern = "Your scores: %s"

export var countdown_time: int = 3

onready var countdown_text: Label = $CountDownInterface/CenterContainer/CountdownTimer
onready var timer_object: Timer = $CountDownInterface/SecondTimer
onready var buttons = $LoseInterface
onready var int_point = $PointsInterface
onready var int_countdown = $CountDownInterface
onready var points_text = $PointsInterface/VerticalContainer/CountText

onready var int_pause = $PauseInterface
onready var music_check = $PauseInterface/VBoxContainer/MusicContainer/MusicSetting
onready var sound_check = $PauseInterface/VBoxContainer/SoundContainer/SoundSetting

onready var lose_scores = $LoseInterface/VBoxContainer/CenterContainer/PointsContainer/ScoresLabel
onready var lose_best_scores = $LoseInterface/VBoxContainer/CenterContainer/PointsContainer/BestScoresLabel

var remaining_time: int = 0
var last_scores: int = 0

signal restart_pressed
signal menu_pressed
signal countdown_ended
signal pause_pressed

func _ready():
	points_text.text = "0"


func start_countdown(time = countdown_time):
	countdown_text.text = time as String
	remaining_time = time
	_set_countdown_state()
	timer_object.start(1)


func set_interface_state(new_state: int):
	match new_state:
		InterfaceStates.COUNTDOWN:
			_set_countdown_state()
		InterfaceStates.POINTS:
			_set_game_state()
		InterfaceStates.LOSE:
			_set_lose_state()
		InterfaceStates.PAUSE:
			_set_pause_state()


func set_points_count(new_value: String):
	last_scores = new_value as int
	points_text.text = new_value


func on_timer_out():
	remaining_time -= 1
	countdown_text.text = remaining_time as String

	if remaining_time > 0:
		timer_object.start(1)
	else:
		emit_signal("countdown_ended")


func on_restart_pressed():
	emit_signal("restart_pressed")


func on_close_pressed():
	emit_signal("menu_pressed")


func _hide_all_interfaces():
	int_countdown.visible = false
	int_point.visible = false
	buttons.visible = false
	int_pause.visible = false

func _set_countdown_state():
	_hide_all_interfaces()
	int_countdown.visible = true


func _set_game_state():
	_hide_all_interfaces()
	points_text.text = "0"
	int_point.visible = true


func _set_lose_state():
	_hide_all_interfaces()
	buttons.visible = true
	var best_scores = Setting.get_setting("player", "best_scores")
	lose_scores.text = last_scores_pattern %[last_scores as String]
	lose_best_scores.text = best_scores_pattern %[best_scores as String]


func _set_pause_state():
	_hide_all_interfaces()
	int_pause.visible = true
	music_check.pressed = Setting.get_setting("audio", "music")
	sound_check.pressed = Setting.get_setting("audio", "sounds")

func _on_music_toggled(button_pressed):
	Setting.set_setting("audio", "music", button_pressed)
	Setting.save_settings()
	MusicPlayer.update_volumes()


func _on_sound_toggled(button_pressed):
	Setting.set_setting("audio", "sounds", button_pressed)
	Setting.save_settings()
	MusicPlayer.update_volumes()


func _on_pause_pressed():
	get_tree().paused = true
	emit_signal("pause_pressed", true)


func _on_continue_pressed():
	get_tree().paused = false
	emit_signal("pause_pressed", false)


