extends Node2D

var placed_letters = 0
var letter_scene = preload("res://Letter/Letter.tscn")  # Correct path to Letter.tscn

func _ready():
	print("Preloaded scene: ", letter_scene)  # Debug print to verify preload
	print("Is letter_scene a PackedScene? ", letter_scene is PackedScene)

	if GameData:  # Check if the singleton is available
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
	
	# Get and display the letters
	GameData.current_letters = get_letters_for_word(GameData.current_word)
	display_letters(GameData.current_letters)

func get_letters_for_word(word):
	var letters = []
	for letter in word.to_upper():
		for letter_data in GameData.alphabet_letters:
			if letter_data["Letter"] == letter:
				letters.append(letter_data)
				break
	return letters

func display_letters(letters):
	var base_position = Vector2(100, 300)  # Adjust base position as needed
	for letter_data in letters:
		print("Instancing letter scene...")  # Debug print before instancing
		var letter_instance = letter_scene.instantiate()  # Create an instance of the preloaded scene
		print("Instanced letter scene: ", letter_instance)
		letter_instance.get_node("Sprite").texture = letter_data["image"]  # Assuming the letter image is on a Sprite node
		randomize()
		letter_instance.position = base_position + Vector2(randi() % 400, randi() % 200)  # Randomized position
		add_child(letter_instance)
		letter_instance.connect("letter_placed_correctly", Callable(self, "_on_letter_placed_correctly"))

func _on_letter_placed_correctly():
	placed_letters += 1
	if placed_letters == GameData.current_word.length():
		placed_letters = 0
		choose_random_word()

func show_completion_message():
	var completion_label = $CompletionLabel
	if completion_label:
		completion_label.text = "Congratulations! You've completed the game!"
		completion_label.visible = true
	else:
		print("Error: 'CompletionLabel' node not found.")
