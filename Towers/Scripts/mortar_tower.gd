extends Node2D

# Enemy storage
var enemies_in_radius = []
var current_target

# Fight variables
var damage = 40
var cooldown = false
var cooldownTimeInSeconds = 6
@export var arrowScene : PackedScene

# Timers
@onready var shootTimer = $shootTimer

# Tower data
var towerName = 'Mortar tower'
var currentLevel = 1
var nextUpgradePrice = 450

# Interface
@onready var towerInterface = get_node("../../CanvasLayer/Panel/TowerInterface")
@onready var trackmanager = get_node("../../trackmanager")
@onready var resourceManager = get_node("../../ResourceManager")
@onready var buildingManager = get_node("../../BuildManager")

# Sprite
var x_scale = 0.75
var y_scale = 0.75

# expl

var saved_pos 

# Called when the node enters the scene tree for the first time.
func _ready():
	$radiusSprite.scale.x = x_scale
	$radiusSprite.scale.y = y_scale

	buildingManager.connect("building_started", bstart)
	buildingManager.connect("building_finished", bfinish)

func bstart():
	$radiusSprite.visible = true

func bfinish():
	$radiusSprite.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_radius_area_entered(area):
	if area.get_parent().is_in_group('enemy') and area.get_parent() not in enemies_in_radius:
		enemies_in_radius.append(area.get_parent())
		if current_target == null:
			current_target = area.get_parent()
			area.get_parent().tower_fixation.append(self)
			if cooldown == false:
				shoot()

func findnewtarget():
	if enemies_in_radius.size() > 0:
		current_target = enemies_in_radius[0]
		enemies_in_radius[0].tower_fixation.append(self)
		if enemies_in_radius[0].dead == false:
			if cooldown == false:
				shoot()
		else:
			enemies_in_radius.erase(enemies_in_radius[0])

func _on_radius_area_exited(area):
	if area.get_parent().is_in_group('enemy'):
		
		if enemies_in_radius.has(area.get_parent()):
			enemies_in_radius.erase(area.get_parent())
			
		if area.get_parent() == current_target:
			current_target = null
			findnewtarget()


func shoot():
	if current_target != null:
		cooldown = true
		shootTimer.start(cooldownTimeInSeconds)
		saved_pos = current_target
		$AnimationPlayer.play("Shot")
		$AudioStreamPlayer2D.stream = load("res://Objects/Sounds/cannonball-89596.mp3")
		$AudioStreamPlayer2D.play()
		$explode.start(0.5)

func _on_shoot_timer_timeout():
	cooldown = false
	if current_target != null:
		shoot()
	else:
		findnewtarget()


func _on_explode_timeout():
	var instance = arrowScene.instantiate()
	add_child(instance)
	instance.my_target = saved_pos
	instance.damage = damage
	instance.explode()
	instance.expl_timer.start(1)
	
func deactivateself():
	$radiusSprite.visible = false
		
func update_tower():
	resourceManager.removeGold(nextUpgradePrice)
	currentLevel += 1
	nextUpgradePrice = nextUpgradePrice * 2
	
	damage = damage * 1.25
	towerInterface.get_child(2).set_text('[center] Seconds per shoot: ' + str(cooldownTimeInSeconds) + '[/center]')
	towerInterface.get_child(3).set_text('[center] Damage per shoot: ' + str(damage) + '[/center]')
	if nextUpgradePrice <= resourceManager.gold:
		towerInterface.get_child(6).visible = true
		towerInterface.get_child(5).set_text(str(nextUpgradePrice))
	else:
		towerInterface.get_child(6).visible = false
		towerInterface.get_child(5).set_text(str(nextUpgradePrice))


func _on_click_input_event(viewport, event, shape_idx):
	if event.is_pressed():
		trackmanager.set_target(self)
		$radiusSprite.visible = true
		towerInterface.visible = true
		towerInterface.get_child(0).set_text('[center]' + towerName + '[/center]')
		towerInterface.get_child(1).set_text('[center]Impact type: Damage [/center]')
		towerInterface.get_child(2).set_text('[center] Seconds per shoot: ' + str(cooldownTimeInSeconds) + '[/center]')
		towerInterface.get_child(3).set_text('[center] Damage per shoot: ' + str(damage) + '[/center]')
		if nextUpgradePrice <= resourceManager.gold:
			towerInterface.get_child(6).visible = true
			towerInterface.get_child(5).set_text(str(nextUpgradePrice))
		else:
			towerInterface.get_child(6).visible = false
			towerInterface.get_child(5).set_text(str(nextUpgradePrice))
