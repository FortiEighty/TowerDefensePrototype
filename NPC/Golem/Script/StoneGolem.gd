extends CharacterBody2D

# Movement Related
var speed = 0.5
@export var target : Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var tilemap = $"../../TileMap"
@export var current_path: Array[Vector2i]
var oiled = false
var dead = false

# Health
var maxHealthPoints = 400
var healthPoints = 400
@onready var healthBar = $ProgressBar

# Manager
@onready var resourceManager = $"../../ResourceManager"
var tower_fixation = []

# Values
var price = 25

func _ready():
	target = get_node("../../Castle")
	healthBar.max_value = maxHealthPoints
	healthBar.value = healthPoints
	moveWorker(self, target.global_position)

func _physics_process(_delta: float) -> void:

	if current_path.is_empty():
		return
		
	var target_position = tilemap.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_position, speed)

	if global_position == target_position:
		current_path.pop_front()

	if target_position != global_position:  # Ensure there is a target and it's not already at that position
		var direction = target_position - global_position
		if direction.x > 0:
			$AnimationPlayer.play("walkRight")
		elif direction.y > 0:
			$AnimationPlayer.play("walk") # down
		elif direction.y < 0:
			$AnimationPlayer.play("walkUp") # up 


func makepath():
	nav_agent.target_position = target.global_position


func moveWorker(worker, toPos):
	if tilemap.is_point_walkable(toPos):
		current_path = tilemap.astar.get_id_path(
		tilemap.local_to_map(global_position),
		tilemap.local_to_map(toPos)
		).slice(1)

func get_damage(amount):
	#print('[Golem] Got ', amount, ' of damage.')
	#$AudioStreamPlayer2D.play()
	if amount >= healthPoints:
		if dead == false:
			die()
			dead = true
	else:
		healthPoints -= amount
		healthBar.value = healthPoints

func _on_castle_check_area_entered(area):
	if area.get_parent().is_in_group('arrow') and area.get_parent().target == self:
		get_damage(area.get_parent().damage)
		area.get_parent().queue_free()
	if area.get_parent().is_in_group('oil') and area.get_parent().target == self:
		if area.get_parent().exploded == false:
			area.get_parent().explode()
			if oiled == false:
				isOiled()
		else:
			if oiled == false:
				isOiled()
	if area.get_parent().is_in_group('oil'):
		if area.get_parent().exploded == true:
			if oiled == false:
				isOiled()
		

func die():
	$AudioStreamPlayer2D.stop()
	resourceManager.addGold(price)
	$AudioStreamPlayer2D.stream = load("res://Objects/Sounds/flint-strike-38491.mp3")
	$AudioStreamPlayer2D.play()
	for tower in tower_fixation:
		tower.enemies_in_radius.erase(self)
		if tower.current_target == self:
			tower.current_target = null
	self.visible = false
	$dietimer.start(1)
	Stats.add_score(15)

func _on_dietimer_timeout():
	queue_free()


func isOiled():
	speed -= 0.3
	oiled = true
	$oiledtimer.start(5)

func _on_oiledtimer_timeout():
	speed += 0.3
	oiled = false
