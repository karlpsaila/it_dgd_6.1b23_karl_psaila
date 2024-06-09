extends Node2D

var placed_letters = 0
var letter_scene = preload("res://Letter/Letter.tscn")
var letter_space_scene = preload("res://LetterSpace/LetterSpace.tscn")

var current_round = 0
var total_rounds = 3
var revealed_indices = []

@onready var images_container = $ImagesContainer/CenterContainer
@onready var progress_bar = $ProgressBar
@onready var completion_label = $CompletionLabel
@onready var restart_button = $RestartButton
@onready var main_menu_button = $MainMenuButton
@onready var hint_button = $HintButton
@onready var hint_label = $HintLabel  # Ensure this is correctly pointing to the Label node

func _ready():
	print("Preloaded scenes: ", letter_scene, letter_space_scene)
	if GameData:
		choose_random_word()
	else:
		print("Error: GameData could not be loaded.")
		
	update_progress_bar()  # Update the progress bar initially

	# Connect the hint button signal
	hint_button.connect("pressed", Callable(self, "_on_hint_button_pressed"))

func choose_random_word():
	randomize()
	var random_index = randi() % GameData.level_2.size()
	GameData.current_word = GameData.level_2[random_index]["word"]
	
	# Display the images
	display_images(GameData.level_2.filter(func(x) -> bool:
		return x["word"] == GameData.current_word
	))

	# Get and display the letters and spaces
	GameData.current_letters = get_letters_for_word(GameData.current_word)
	display_letters_and_spaces(GameData.current_letters)

	# Reset revealed indices and update hint label
	revealed_indices.clear()
	update_hint_label()

func display_images(images):
	var image_nodes = [images_container.get_node("Image1"), images_container.get_node("Image2"), images_container.get_node("Image3")]
	var total_width = 0
	var image_positions = []
	
	# Calculate total width and positions
	for i in range(min(image_nodes.size(), images.size())):
		var image_node = image_nodes[i]
		if image_node:
			var texture = load(images[i]["image"].resource_path)
			image_node.texture = texture
			image_node.scale = Vector2(0.5, 0.5)  # Scale image to half size
			total_width += texture.get_size().x * 0.5
			image_positions.append(texture.get_size().x * 0.5)
		else:
			print("Error: 'Image' node not found for index: ", i)
	
	# Center images
	var start_x = -total_width / 2
	for i in range(image_positions.size()):
		image_nodes[i].position = Vector2(start_x + image_positions[i] / 2, 0)
		start_x += image_positions[i]

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
		current_round += 1  # Increment the round counter
		update_progress_bar()  # Update the progress bar

		if GameData.level_2.size() > 1:
			GameData.level_2.erase(GameData.level_2.find({"word": GameData.current_word}))
			choose_random_word()
		else:
			show_completion_message()

func show_completion_message():
	if completion_label:
		completion_label.text = "Congratulations! You've completed the game!"
		completion_label.visible = true
	else:
		print("Error: 'CompletionLabel' node not found.")

func _on_RestartButton_pressed():
	GameData.level_2 = [
		{"word": "chicken", "image": preload("res://Resources/Images/c1.png")},
		{"word": "chicken", "image": preload("res://Resources/Images/c2.png")},
		{"word": "chicken", "image": preload("res://Resources/Images/c3.png")},
		{"word": "bus", "image": preload("res://Resources/Images/bus1.png")},
		{"word": "bus", "image": preload("res://Resources/Images/bus2.png")},
		{"word": "bus", "image": preload("res://Resources/Images/bus3.png")},
		{"word": "water", "image": preload("res://Resources/Images/water1.png")},
		{"word": "water", "image": preload("res://Resources/Images/water2.png")},
		{"word": "water", "image": preload("res://Resources/Images/water3.png")}
	]
	placed_letters = 0
	current_round = 0  # Reset the round counter
	update_progress_bar()  # Reset the progress bar
	choose_random_word()

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")

func update_progress_bar():
	if progress_bar:
		progress_bar.value = current_round
	else:
		print("Error: 'ProgressBar' node not found.")

func _on_hint_button_pressed():
	# Reveal one random unrevealed letter
	if revealed_indices.size() < GameData.current_word.length():
		var unrevealed_indices = []
		for i in range(GameData.current_word.length()):
			if i not in revealed_indices:
				unrevealed_indices.append(i)
		
		if unrevealed_indices.size() > 0:
			var random_index = unrevealed_indices[randi() % unrevealed_indices.size()]
			revealed_indices.append(random_index)
			update_hint_label()

func update_hint_label():
	var hint_text = ""
	for i in range(GameData.current_word.length()):
		if i in revealed_indices:
			hint_text += GameData.current_word[i].to_upper()
		else:
			hint_text += "_"
	hint_label.text = hint_text
