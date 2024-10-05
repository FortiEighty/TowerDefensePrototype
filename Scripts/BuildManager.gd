extends Node2D

# Managers 

@onready var buildingGhost = $"../BuildingGhost"
@onready var resourceManager = $"../ResourceManager"

# Conditions

# Tilemap 

@onready var tileMap = $"../TileMap"

var isPlacingTower = false

# Signals

signal building_started
signal building_finished

# Towers

var tower_scene = load("res://Towers/Scenes/arrow_tower.tscn")
var currentTower


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if isPlacingTower == true:
		buildingGhost.position = get_global_mouse_position()
		if buildingGhost.get_child(2).get_overlapping_areas().size() > 0:
			buildingGhost.modulate = Color.DARK_RED
		else:
			var mouse_pos = get_global_mouse_position()
			var mouse_tile_pos = tileMap.local_to_map(mouse_pos)
			var data = tileMap.get_cell_tile_data(0, mouse_tile_pos)
			if data:
				if data.get_custom_data("allowance") == false:
					buildingGhost.modulate = Color.DARK_RED
				else:
					buildingGhost.modulate = Color(1,1,1,1)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			if isPlacingTower == true and currentTower.cost <= resourceManager.gold:
				var mouse_pos = get_global_mouse_position()
				var mouse_tile_pos = tileMap.local_to_map(mouse_pos)
				var data = tileMap.get_cell_tile_data(0, mouse_tile_pos)
				if buildingGhost.get_child(2).get_overlapping_areas().size() == 0:
					if data:
						if data.get_custom_data("allowance") == true:
							var instance = currentTower.scene.instantiate()
							instance.position = get_global_mouse_position()
							isPlacingTower = false
							buildingGhost.visible = false
							add_child(instance)
							resourceManager.removeGold(currentTower.cost)
							$"../AudioStreamPlayer2D".stream = load("res://Objects/Sounds/poof-of-smoke-87381.mp3")
							$"../AudioStreamPlayer2D".play()
							building_finished.emit()
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if isPlacingTower == true:
				isPlacingTower = false
				#currentTower == null
				buildingGhost.visible = false

func _on_button_pressed():
	isPlacingTower = true
	buildingGhost.visible = true

func startBuildingTower(tower):
	building_started.emit()
	currentTower = tower
	isPlacingTower = true
	buildingGhost.visible = true
	buildingGhost.get_child(0).texture = tower.mainSprite
	buildingGhost.get_child(1).scale.x = tower.x_scale
	buildingGhost.get_child(1).scale.y = tower.y_scale
