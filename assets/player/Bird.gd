extends Node2D

signal s_bird_hit

var flap_power : float = 180
var gravity : float = 640
var default_y_speed : float = 160
var y_speed : float = 80
var is_bird_active = false


func _process(delta):
	if !is_bird_active:
		return
	
	y_speed += gravity * delta
	y_speed = min(y_speed, default_y_speed)
	
	if Input.is_action_just_pressed("screen_tap"):
		y_speed = -flap_power
		
	global_position.y += y_speed * delta
	
	var speed_variation = default_y_speed + flap_power
	var rotation_variation = 140
	var max_angle = 70
	var spr_rotation = rotation_variation * y_speed/speed_variation
	self.rotation_degrees = spr_rotation


func on_bird_hit(area:Area2D):
	print(area.collision_layer)
	emit_signal("s_bird_hit")


func set_bird_active(active: bool):
	is_bird_active = active
