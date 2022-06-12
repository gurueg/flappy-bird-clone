extends Control

enum InterfaceStates {COUNTDOWN = 0, POINTS = 1, LOSE = 2}

export var countdown_time: int = 3

onready var overlay = $BlackOverlay
onready var countdown_text: Label = $CenterContainer/CountdownTimer
onready var timer_object: Timer = $SecondTimer
onready var buttons = $ButtonsContainer
onready var points_text = $VerticalContainer/CountText

var remaining_time: int = 0

signal restart_pressed
signal close_pressed
signal countdown_ended


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


func set_points_count(new_value: String):
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
	emit_signal("close_pressed")


func _set_countdown_state():
	overlay.visible = true
	countdown_text.visible = true
	buttons.visible = false
	points_text.visible = false


func _set_game_state():
	overlay.visible = false
	countdown_text.visible = false
	buttons.visible = false
	points_text.visible = true


func _set_lose_state():
	overlay.visible = true
	countdown_text.visible = false
	buttons.visible = true
	points_text.visible = false
