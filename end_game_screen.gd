extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$"CanvasLayer/Panel/CURRENT SCORE".set_text('[center] Your score: ' + str(Stats.score) + '[/center]')
	$"CanvasLayer/Panel/HIGH SCORE".set_text('[center] Your highest score: ' + str(Stats.high_score) + '[/center]')


func _on_button_pressed():
	get_tree().change_scene_to_file("res://node_2d.tscn")
