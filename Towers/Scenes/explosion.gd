extends Node2D


@onready var expl_timer = $Timer
@onready var my_target
# Called when the node enters the scene tree for the first time.
var damage = 50

func explode():
	if is_instance_valid(my_target):
		global_position = my_target.global_position
	else:
		die()
	

func _on_timer_timeout():
	if is_instance_valid(my_target):
		global_position = my_target.global_position
		visible = true
		$AnimationPlayer.play("explosion")
		$AudioStreamPlayer2D.stream = load("res://Objects/Sounds/medium-explosion-40472.mp3")
		$AudioStreamPlayer2D.play()
		for body in $Area2D.get_overlapping_bodies():
			if body.is_in_group('enemy'):
				body.get_damage(damage)
		$Timer2.start(1)
	else:
		die()

	
func die():
	queue_free()


func _on_timer_2_timeout():
	die()
