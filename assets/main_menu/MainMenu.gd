extends Control

const game_scene: String = "res://assets/game_screen/GameScene.tscn"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	get_node("Camera2D/AnimationPlayer").play("to_settings")
	pass


func _on_play_pressed():
	get_tree().change_scene(game_scene)
	queue_free()
