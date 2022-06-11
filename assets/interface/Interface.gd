extends Control


signal restart_pressed
signal close_pressed


func on_restart_pressed():
	emit_signal("restart_pressed")


func on_close_pressed():
	emit_signal("close_pressed")
