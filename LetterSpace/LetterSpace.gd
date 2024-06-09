extends Area2D

var correct_letter = ""

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	print("LetterSpace ready: ", name, ", correct_letter: ", correct_letter)

func _on_body_entered(body):
	print("Body entered letter space: ", body.name)
	if body.has_method("check_correct_position"):
		body.check_correct_position()
