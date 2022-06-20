extends Node2D

signal on_game_end

const background_size : float = 384.0
const tubes_air_space_min = 60
const bird_speed : float = 80.0
const tubes_max_height : float = 90.0
const tubes_min_height : float = -20.0
const tubes_scene = preload("../tubes/Tubes.tscn")

var tubes_distance : float = 90
var previous_bottom_height: float = 90
var tubes_list : Array = []

var start_position : float = 0
var tube_deafult_position: float = 210
var tubes_air_space : float = 90.0
var flied_distance : float = 0

var _tubes_count: int = 0
var is_game_over: bool = false
var is_game_started: bool = false

onready var background_root = $BackgroundRoot
onready var ground_root = $Ground
onready var interface = $InterfaceCanvas/Interface
onready var bird = $Bird


func _ready():
	_create_tube(50, previous_bottom_height)
	_create_tube(130, previous_bottom_height)
	_create_tube(210, previous_bottom_height)
	randomize()
	
	interface.set_interface_state(interface.InterfaceStates.COUNTDOWN)
	interface.start_countdown(3)


func _process(delta):
	if is_game_over or !is_game_started: 
		return
	
	var delta_distance = bird_speed * delta
	flied_distance += delta_distance
	
	if flied_distance >= tubes_distance:
		flied_distance = 0
		_create_tube(tube_deafult_position, previous_bottom_height)
		
	_move_environment(delta_distance)


func on_bird_collision():
	is_game_over = true
	interface.set_interface_state(interface.InterfaceStates.LOSE)
	bird.set_bird_active(false)


func on_tube_counted():
	_tubes_count += 1
	interface.set_points_count(_tubes_count  as String)
	MusicPlayer.play_sound("point")
	
	if _tubes_count%10 == 0:
		tubes_air_space -= 10
		tubes_air_space = max(tubes_air_space_min, tubes_air_space)


func on_countdown_ended():
	is_game_started = true
	bird.set_bird_active(true)
	interface.set_interface_state(interface.InterfaceStates.POINTS)


func on_button_restart_pressed():
	get_tree().reload_current_scene()


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
	var bottom_height = prev_bottom + randi()%50 - 25
	
	bottom_height = min(tubes_max_height, bottom_height)
	bottom_height = max(tubes_min_height, bottom_height)
	
	previous_bottom_height = bottom_height
	new_tube.init(position, tubes_air_space, bottom_height)
	
	connect("on_game_end", new_tube, "on_game_end")
	new_tube.connect("tubes_counted", self, "on_tube_counted")
	
	tubes_list.append(new_tube)



func _on_pause_pressed(is_paused: bool):
	if is_paused:
		interface.set_interface_state(interface.InterfaceStates.PAUSE)
	else:
		interface.set_interface_state(interface.InterfaceStates.POINTS)


func _on_button_menu_pressed():
	get_tree().change_scene("res://assets/main_menu/MainMenu.tscn")
	queue_free()
