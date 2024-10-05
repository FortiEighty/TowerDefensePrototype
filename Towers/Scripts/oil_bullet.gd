extends Node2D

var speed = 500  # Movement speed
var target: Node2D
var damage
var exploded = false 

func _ready():
	$SelfDelete.start(4)
	if target != null:
		# Rotate towards the target once when instantiated
		rotate_towards_target(target)

func _process(delta: float):
	if target != null:
		# Move towards the target continuously
		move_towards_target(target, delta)
		if global_position == target.global_position:
			queue_free()

func rotate_towards_target(target: Node2D):
	var direction = (target.global_position - self.global_position).normalized()
	var angle = atan2(direction.y, direction.x)
	#rotation = angle

func move_towards_target(target: Node2D, delta: float):
	var direction = (target.global_position - self.global_position).normalized()
	global_position += direction * speed * delta

func explode():
	$SelfDelete.stop()
	exploded = true
	$Sprite2D.visible = false
	$SplashSprite.visible = true
	target = null
	$AnimationPlayer.play('splash')
	
	$Area2D/CollisionShape2D.global_scale.x = 2.5
	$Area2D/CollisionShape2D.global_scale.y = 2.5
	$DeleteTimer.start(5)


func _on_delete_timer_timeout():
	queue_free()


func _on_self_delete_timeout():
	queue_free()
