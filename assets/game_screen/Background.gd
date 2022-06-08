extends Node2D

export var backgrond_speed : float = 60
export var background_size : float = 384


func _process(delta):
	position.x -= backgrond_speed * delta
	if position.x <= -background_size:
		position.x += background_size
		

func _on_game_end():
	backgrond_speed = 0
