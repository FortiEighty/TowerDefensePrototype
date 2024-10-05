extends CharacterBody2D

const speed = 20

@export var target : Node2D
@onready var nav_agent := $"../NavigationAgent2D" as NavigationAgent2D

func _ready():
	target = $"../../../Castle"
	makepath()
	

func _physics_process(delta):
	var dir = to_local(nav_agent.get_next_path_position().normalized())
	velocity = dir * speed
	move_and_slide()

func makepath():
	nav_agent.target_position = target.global_position
	print('triggered')
