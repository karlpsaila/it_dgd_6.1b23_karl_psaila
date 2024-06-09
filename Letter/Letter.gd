extends Area2D

var draggable = false
var offset = Vector2()
var initial_position = Vector2()
var is_locked = false
var tolerance = 50  # Allowable distance to snap to the correct position

signal letter_placed_correctly

func _ready():
	connect("input_event", Callable(self, "_on_input_event"))
	initial_position = position
	var sprite = $Sprite
	var collision_shape = $CollisionShape2D
	sprite.scale = Vector2(0.5, 0.5)  # Adjust the scale to make the image smaller
	collision_shape.scale = sprite.scale  # Scale the collision shape to match the sprite
	print("Letter ready: ", name, " at initial position: ", initial_position)

func _on_input_event(viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not is_locked:
				draggable = true
				offset = global_position - event.global_position
				print("Letter picked up: ", name, " from position: ", position)
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if draggable:
				draggable = false
				print("Letter dropped at position: ", global_position)
				check_correct_position()

func _process(delta):
	if draggable and not is_locked:
		global_position = get_global_mouse_position() + offset

func reset_position():
	position = initial_position
	print("Letter reset to initial position: ", name)

func check_correct_position():
	print("Checking correct position for letter: ", name)
	var closest_area = null
	var closest_distance = tolerance + 1  # Initialize with a value larger than tolerance

	for area in get_parent().get_children():
		if area.has_method("correct_letter"):
			var distance = global_position.distance_to(area.global_position)
			print("Checking area: ", area.name, " distance: ", distance)
			if distance < closest_distance:
				closest_distance = distance
				closest_area = area

	if closest_area:
		print("Closest area: ", closest_area.name, " correct_letter: ", closest_area.correct_letter)
		if closest_area.correct_letter == name.split("_")[-1] and closest_distance <= tolerance:
			print("Correct letter placed within tolerance")
			global_position = closest_area.global_position
			is_locked = true
			$Sprite.modulate = Color(0, 1, 0)
			print("Letter ", name, " placed correctly in ", closest_area.name)
			emit_signal("letter_placed_correctly")
		else:
			print("Letter ", name, " does not match ", closest_area.name)
			reset_position()
	else:
		print("No suitable area found for letter: ", name)
		reset_position()

func _on_area_entered(area):
	print("Area entered: ", area.name)
	if area.has_method("correct_letter"):
		print("Area correct letter: ", area.correct_letter)
		if area.correct_letter == name.split("_")[-1]:
			print("Correct letter placed")
			global_position = area.global_position
			is_locked = true  # Lock the letter
			$Sprite.modulate = Color(0, 1, 0)  # Change color to indicate correct placement
			emit_signal("letter_placed_correctly")
		else:
			print("Incorrect letter")
			reset_position()
