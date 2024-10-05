extends Node2D

# Storage
var gold = 300

# UI
@onready var textHolder = $"../CanvasLayer/Panel/Gold_Text"

func _ready():
	textHolder.set_text('[center]' + str(gold) + '[/center]')

func addGold(amount):
	gold += amount
	textHolder.set_text('[center]' + str(gold) + '[/center]')
	
func removeGold(amount):
	gold -= amount
	textHolder.set_text('[center]' + str(gold) + '[/center]')
