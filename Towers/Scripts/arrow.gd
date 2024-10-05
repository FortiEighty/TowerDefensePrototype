extends Node2D

var speed = 500  # Movement speed
var target: Node2D
var damage

func _ready():
	if target != null:
		# Rotate towards the target once when instantiated
		rotate_towards_target(target)

func _process(delta: float):
	if target != null:
		# Move towards the target continuously
		move_towards_target(target, delta)
		if global_position == target.global_position:
			queue_free()
	
	if target == null:
		queue_free()

func rotate_towards_target(target: Node2D):
	var direction = (target.global_position - self.global_position).normalized()
	var angle = atan2(direction.y, direction.x)
	rotation = angle

func move_towards_target(target: Node2D, delta: float):
	var direction = (target.global_position - self.global_position).normalized()
	global_position += direction * speed * delta

