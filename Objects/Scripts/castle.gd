extends Node2D

# Statuses
var healthpoints = 10

# UI Elements
@onready var HP_Status = $"../CanvasLayer/Panel/HP_Text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_get_damage_area_area_entered(area):
	if area.get_parent().is_in_group('enemy'):
		healthpoints -= 1
		area.get_parent().queue_free()
		
		HP_Status.set_text('[center]' + str(healthpoints) + '[/center]')
		if healthpoints == 0:
			game_over()

func game_over():
	get_tree().change_scene_to_file("res://end_game_screen.tscn")
