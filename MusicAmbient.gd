extends AudioStreamPlayer2D


@onready var musicLibrary = [
	load("res://Music/song1.wav"), load("res://Music/song2.wav"), load("res://Music/song3.wav"), load("res://Music/song4.wav")
	
]

var MLIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	stream = musicLibrary[MLIndex]
	playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_finished():
	MLIndex += 1
	if MLIndex >= musicLibrary.size():
		MLIndex = 0
	stream = musicLibrary[MLIndex]
	playing = true
