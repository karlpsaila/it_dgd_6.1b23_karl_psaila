extends Node

var level_1_images = [
	{"word": "cat", "image": preload("res://Resources/Images/cat.png")},
	{"word": "wolf", "image": preload("res://Resources/Images/wolf.png")},
	{"word": "boat", "image": preload("res://Resources/Images/boat.png")},
	{"word": "bread", "image": preload("res://Resources/Images/bread.png")},
	{"word": "cannon", "image": preload("res://Resources/Images/cannon.png")},
	{"word": "car", "image": preload("res://Resources/Images/car.png")},
	{"word": "castle", "image": preload("res://Resources/Images/castle.png")},
	{"word": "pasta", "image": preload("res://Resources/Images/pasta.png")},
]

# Alphabet letters and corresponding images
var alphabet_letters = [
	{"Letter": "A", "image": preload("res://Resources/Alphabet/A.png")},
	{"Letter": "B", "image": preload("res://Resources/Alphabet/B.png")},
	{"Letter": "C", "image": preload("res://Resources/Alphabet/C.png")},
	{"Letter": "D", "image": preload("res://Resources/Alphabet/D.png")},
	{"Letter": "E", "image": preload("res://Resources/Alphabet/E.png")},
	{"Letter": "F", "image": preload("res://Resources/Alphabet/F.png")},
	{"Letter": "G", "image": preload("res://Resources/Alphabet/G.png")},
	{"Letter": "H", "image": preload("res://Resources/Alphabet/H.png")},
	{"Letter": "I", "image": preload("res://Resources/Alphabet/I.png")},
	{"Letter": "J", "image": preload("res://Resources/Alphabet/J.png")},
	{"Letter": "K", "image": preload("res://Resources/Alphabet/K.png")},
	{"Letter": "L", "image": preload("res://Resources/Alphabet/L.png")},
	{"Letter": "M", "image": preload("res://Resources/Alphabet/M.png")},
	{"Letter": "N", "image": preload("res://Resources/Alphabet/N.png")},
	{"Letter": "O", "image": preload("res://Resources/Alphabet/O.png")},
	{"Letter": "P", "image": preload("res://Resources/Alphabet/P.png")},
	{"Letter": "Q", "image": preload("res://Resources/Alphabet/Q.png")},
	{"Letter": "R", "image": preload("res://Resources/Alphabet/R.png")},
	{"Letter": "S", "image": preload("res://Resources/Alphabet/S.png")},
	{"Letter": "T", "image": preload("res://Resources/Alphabet/T.png")},
	{"Letter": "U", "image": preload("res://Resources/Alphabet/U.png")},
	{"Letter": "V", "image": preload("res://Resources/Alphabet/V.png")},
	{"Letter": "W", "image": preload("res://Resources/Alphabet/W.png")},
	{"Letter": "X", "image": preload("res://Resources/Alphabet/X.png")},
	{"Letter": "Y", "image": preload("res://Resources/Alphabet/Y.png")},
	{"Letter": "Z", "image": preload("res://Resources/Alphabet/Z.png")}
]

var current_word = ""
var current_letters = []

# Track global dragging state
var is_dragging = false

func _ready():
	print("GameData singleton is ready!")

