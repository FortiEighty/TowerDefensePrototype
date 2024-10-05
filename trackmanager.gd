extends Node2D

var currentTarget
var oldtarget

func set_target(target):
	if target != currentTarget:
		oldtarget = currentTarget
		currentTarget = target
	
	if oldtarget:	
		oldtarget.deactivateself()


func _on_close_pressed():
	$"../CanvasLayer/Panel/TowerInterface".visible = false
	if currentTarget:
		currentTarget.deactivateself()

func upgrade_tower():
	currentTarget.update_tower()

func _on_button_pressed():
	upgrade_tower()
