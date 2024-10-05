extends Node

const SAVE_PATH = "user://entity.ini"

var score = 0
var high_score = 0

func _ready():
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	var sections = config.get_sections()
	
	for section in sections:
		_load(section)

func add_score(amount):
	score += amount
	if score > high_score:
		high_score = score
		var config = ConfigFile.new()
		config.load(SAVE_PATH)
		config.clear()
		config.save(SAVE_PATH)
		_save()


func _save():
	print('saving')
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	
	config.set_value(name, 'highscore', high_score)
	config.save(SAVE_PATH)
	
func _load(section):
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	high_score = config.get_value(section, 'highscore')
