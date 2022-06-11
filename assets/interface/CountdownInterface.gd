extends Control


export var countdown_time: int = 3
onready var text_object: Label = $CountdownTimer
onready var timer_object: Timer = $SecondTimer

var remaining_time: int = 0

signal countdown_ended


func _ready():
	text_object.text = countdown_time as String
	remaining_time = countdown_time


func start_countdown(time = countdown_time):
	timer_object.start(1)


func on_timer_out():
	remaining_time -= 1
	text_object.text = remaining_time as String

	if remaining_time > 0:
		timer_object.start(1)
	else:
		emit_signal("countdown_ended")

