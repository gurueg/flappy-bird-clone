extends Node2D

signal tubes_counted

onready var bottom_tube = $BottomTube
onready var top_tube = $TopTube


func init(position:float, free_space:float, bottom_height:float):
	global_position.x = position
	bottom_tube.position.y = bottom_height
	top_tube.position.y = bottom_height - free_space - (randi()%20 + 10)



func _on_count_area_entered(area):
	emit_signal("tubes_counted")
