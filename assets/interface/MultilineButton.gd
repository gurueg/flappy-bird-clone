tool
extends Button


export var button_text : String = ""
export var button_min_width : float
onready var text_object : RichTextLabel = $ButtonText


var format_string : String = "[center]%s[/center]"


func _process(delta):
	if button_text == "":
		return
		
	text_object.bbcode_text = format_string % [button_text.c_unescape()] 
	
	if button_min_width:
		rect_min_size.x = button_min_width
	yield(get_tree(), "idle_frame")
	rect_min_size.y = text_object.get_content_height()

