extends Node2D

var placed_letters = 0
var letter_scene = preload("res://Letter/Letter.tscn")
var letter_space_scene = preload("res://LetterSpace/LetterSpace.tscn")

func _ready():
	print("Preloaded scenes: ", letter_scene, letter_space_scene)
	if GameData:
		choose_random_word()
	else:
		print("Error: GameData could not be loaded.")

func choose_random_word():
	randomize()
	var random_index = randi() % GameData.level_1_images.size()
	GameData.current_word = GameData.level_1_images[random_index]["word"]
	
	# Display the image
	var image_node = $Image
	if image_node:
		image_node.texture = GameData.level_1_images[random_index]["image"]
	else:
		print("Error: 'Image' node not found.")
	
	# Get and display the letters and spaces
	GameData.current_letters = get_letters_for_word(GameData.current_word)
	display_letters_and_spaces(GameData.current_letters)

func get_letters_for_word(word):
	var letters = []
	for letter in word.to_upper():
		for letter_data in GameData.alphabet_letters:
			if letter_data["Letter"] == letter:
				letters.append(letter_data)
				break
	return letters

func display_letters_and_spaces(letters):
	var viewport_height = get_viewport_rect().size.y
	var letter_space_start_position = Vector2(100, viewport_height - 100)  # Bottom of the screen
	var letter_space_gap = 10  # Gap between letter spaces

	# Clear existing letter spaces and letters
	for child in get_children():
		if child is Area2D and (child.has_method("correct_letter") or child.has_method("_on_input_event")):
			remove_child(child)
			child.queue_free()

	var current_x = letter_space_start_position.x

	for i in range(letters.size()):
		var letter_data = letters[i]
		print("Creating space for letter: ", letter_data["Letter"])

		# Instantiate letter space
		var space_instance = letter_space_scene.instantiate()
		space_instance.correct_letter = letter_data["Letter"]
		space_instance.name = "LetterSpace_" + str(i) + "_" + letter_data["Letter"]  # Set unique name for debugging
		space_instance.position = Vector2(current_x, letter_space_start_position.y)
		current_x += space_instance.get_node("Sprite").texture.get_size().x + letter_space_gap

		add_child(space_instance)
		print("LetterSpace created: ", space_instance.name, " at position: ", space_instance.position)

	for i in range(letters.size()):
		var letter_data = letters[i]

		# Instantiate letter scene
		var letter_instance = letter_scene.instantiate()  # Create an instance of the preloaded scene
		var sprite = letter_instance.get_node("Sprite")  # Get the Sprite node
		sprite.texture = letter_data["image"]  # Set the texture to the correct letter image
		sprite.scale = Vector2(0.5, 0.5)  # Adjust the scale to make the image smaller
		letter_instance.name = "Letter_" + str(i) + "_" + letter_data["Letter"]  # Set unique name for debugging
		randomize()
		letter_instance.position = Vector2(randi() % 400 + 100, randi() % 200 + 300)  # Randomized position
		add_child(letter_instance)
		letter_instance.connect("letter_placed_correctly", Callable(self, "_on_letter_placed_correctly"))
		print("Letter created: ", letter_instance.name, " at position: ", letter_instance.position)

func _on_letter_placed_correctly():
	placed_letters += 1
	if placed_letters == GameData.current_word.length():
		placed_letters = 0
		if GameData.level_1_images.size() > 1:
			GameData.level_1_images.erase(GameData.level_1_images.find({"word": GameData.current_word}))
			choose_random_word()
		else:
			show_completion_message()

func show_completion_message():
	var completion_label = $CompletionLabel
	if completion_label:
		completion_label.text = "Congratulations! You've completed the game!"
		completion_label.visible = true
	else:
		print("Error: 'CompletionLabel' node not found.")

func _on_RestartButton_pressed():
	GameData.level_1_images = [
		{"word": "cat", "image": preload("res://Resources/Images/cat.png")},
		{"word": "wolf", "image": preload("res://Resources/Images/wolf.png")},
		{"word": "boat", "image": preload("res://Resources/Images/boat.png")},
		{"word": "bread", "image": preload("res://Resources/Images/bread.png")}
	]
	placed_letters = 0
	choose_random_word()

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
