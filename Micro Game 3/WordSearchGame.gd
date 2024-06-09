extends Control

var grid_size = 6  # Default grid size
var letter_buttons = []
var selected_indices = []
var audio_player
var current_word_data
var used_words = []

func _ready():
	randomize()  # Initialize the random number generator
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	$ReplayButton.connect("pressed", Callable(self, "_on_replay_button_pressed"))
	start_round()

func start_round():
	if GameData.level_3.size() > 0:
		current_word_data = GameData.get_random_word_and_audio()
		# Ensure the word is not repeated
		while current_word_data["word"] in used_words:
			current_word_data = GameData.get_random_word_and_audio()
		used_words.append(current_word_data["word"])
		$CurrentWordLabel.text = "Find the word: " + current_word_data["word"]
		fill_grid()
		play_audio(current_word_data["audio_file"])
	else:
		show_completion_message()

func fill_grid():
	# Clear previous buttons
	for child in $LetterGrid.get_children():
		child.queue_free()
	
	letter_buttons.clear()
	var letters = create_grid_with_word()

	for i in range(grid_size * grid_size):
		var button = Button.new()
		button.text = letters[i]
		button.connect("pressed", Callable(self, "_on_letter_pressed").bind(i))
		$LetterGrid.add_child(button)
		letter_buttons.append(button)

func create_grid_with_word():
	var letters = []
	for i in range(grid_size * grid_size):
		letters.append(" ")

	var word = current_word_data["word"]
	var word_length = word.length()
	var placed = false

	while not placed:
		var direction = randi() % 2  # 0 for horizontal, 1 for vertical
		if direction == 0:  # Horizontal
			var row = randi() % grid_size
			var col = randi() % (grid_size - word_length + 1)
			var index = row * grid_size + col
			if can_place_word(letters, index, word_length, grid_size, true):
				for i in range(word_length):
					letters[index + i] = word[i]
				placed = true
		else:  # Vertical
			var row = randi() % (grid_size - word_length + 1)
			var col = randi() % grid_size
			var index = row * grid_size + col
			if can_place_word(letters, index, word_length, grid_size, false):
				for i in range(word_length):
					letters[index + i * grid_size] = word[i]
				placed = true

	# Fill the rest of the grid with random letters
	for i in range(grid_size * grid_size):
		if letters[i] == " ":
			letters[i] = char(int(randf() * (90 - 65 + 1) + 65))  # Generate random uppercase letters

	return letters

func can_place_word(letters, start_index, length, grid_size, horizontal):
	if horizontal:
		var row = start_index / grid_size
		for i in range(length):
			if letters[start_index + i] != " ":
				return false
	else:
		var col = start_index % grid_size
		for i in range(length):
			if letters[start_index + i * grid_size] != " ":
				return false
	return true

func _on_letter_pressed(index):
	if index in selected_indices:
		return

	selected_indices.append(index)
	var selected_letter = letter_buttons[index].text

	if selected_letter in current_word_data["word"]:
		letter_buttons[index].modulate = Color(0, 1, 0)  # Turn green if selected letter is in the word
	else:
		letter_buttons[index].modulate = Color(1, 0, 0)  # Turn red if selected letter is not in the word
	
	check_selection()

func check_selection():
	var selected_word = ""
	for i in selected_indices:
		selected_word += letter_buttons[i].text

	if all_letters_in_word(selected_word, current_word_data["word"]):
		$FeedbackLabel.text = "Correct!"
		reset_selection()
		start_round()  # Start the next round
	elif selected_word.length() >= current_word_data["word"].length():
		$FeedbackLabel.text = "Try again!"
		reset_selection()

func all_letters_in_word(selected_word, target_word):
	var selected_letters = selected_word.split("")
	var target_letters = target_word.split("")

	for letter in selected_letters:
		if letter in target_letters:
			# Remove the first occurrence of the letter
			var index = target_letters.find(letter)
			target_letters.remove_at(index)
		else:
			return false

	return target_letters.size() == 0

func reset_selection():
	for i in selected_indices:
		letter_buttons[i].modulate = Color(1, 1, 1)  # Reset to white
	selected_indices.clear()

func _on_replay_button_pressed():
	play_audio(current_word_data["audio_file"])

func play_audio(audio_file):
	if audio_file:
		audio_player.stream = audio_file
		audio_player.play()

func show_completion_message():
	$FeedbackLabel.text = "Congratulations! You've completed all the rounds!"
