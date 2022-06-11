extends Control


onready var text_object: Label = $CountText


func _ready():
	text_object.text = "0"


func set_points_count(new_value: String):
	text_object.text = new_value

