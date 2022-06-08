extends Node2D

signal on_game_end

const background_size : float = 384.0
const tubes_air_space_min = 30
const tubes_scene = preload("../tubes/Tubes.tscn")
const bird_speed : float = 80.0

onready var background_root = $BackgroundRoot
onready var ground_root = $Ground
onready var text_label = $CanvasLayer/CountText

var tubes_distance : float = 80
var previous_bottom_height: float = 70
var tubes_list : Array = []

var start_position : float = 0
var tube_deafult_position: float = 280
var tubes_air_space = 80
var flied_distance : float = 0

var _tubes_count = 0
var is_game_over = false



func _ready():
	_create_tube(120, previous_bottom_height)
	_create_tube(200, previous_bottom_height)
	_create_tube(280, previous_bottom_height)
	randomize()



func _process(delta):
	if is_game_over: 
		return
	
	var delta_distance = bird_speed * delta
	flied_distance += delta_distance
	
	if flied_distance >= tubes_distance:
		flied_distance = 0
		_create_tube(tube_deafult_position, previous_bottom_height)
		
	_move_environment(delta_distance)



func _move_environment(distance: float):
	background_root.position.x -= distance
	ground_root.position.x -= distance
	for tube_object in tubes_list:
		if tube_object != null:
			tube_object.global_position.x -= distance
			if tube_object.position.x <= -background_size:
				tube_object.queue_free()
				tubes_list.remove(tubes_list.find(tube_object))
	
	if background_root.position.x <= -background_size:
		background_root.position.x += background_size
		ground_root.position.x += background_size



func _create_tube(position, prev_bottom):
	var new_tube = tubes_scene.instance()
	add_child(new_tube)
	var bottom_height = prev_bottom + randi()%30 - 15
	previous_bottom_height = bottom_height
	new_tube.init(position, tubes_air_space, bottom_height)
	
	connect("on_game_end", new_tube, "on_game_end")
	new_tube.connect("tubes_counted", self, "on_tube_counted")
	
	tubes_list.append(new_tube)



func on_bird_collision():
	is_game_over = true
	

func on_tube_counted():
	_tubes_count += 1
	text_label.text = _tubes_count as String
	
	if _tubes_count%10 == 0:
		tubes_air_space -= 10
		tubes_air_space = max(tubes_air_space_min, tubes_air_space)

