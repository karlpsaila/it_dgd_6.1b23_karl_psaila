extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#load level 1
func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://Micro Game 1/Micro Game 1.tscn")
	pass # Replace with function body.


func _on_texture_button_2_pressed():
	
	pass # Replace with function body.


func _on_texture_button_3_pressed():
	get_tree().change_scene_to_file("res://Micro Game 3/Micro Game 3.tscn")
	pass # Replace with function body.
