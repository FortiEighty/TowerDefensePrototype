extends Node2D

@export var tile_map: TileMap  # Reference to the TileMap node

var last_point
var finish_point

# Portal
@export var portal : Node2D

# Lists

@onready var towerList = load("res://Towers/R_Towers/towerTypeList.tres")

# Templates
@onready var templateButton = $CanvasLayer/ButtonContainer/Button
var theme = load("res://theme.tres")

# Managers
@onready var buildingManager = $BuildManager

# Objects
@export var castleScene : PackedScene
@export var portalScene : PackedScene

# Tooltip
@onready var tooltip = $CanvasLayer/Panel/Tooltip
@onready var tooltip_header = $CanvasLayer/Panel/Tooltip/Header
@onready var tooltip_desc = $CanvasLayer/Panel/Tooltip/Desc
@onready var tooltip_price = $CanvasLayer/Panel/Tooltip/Price


func _ready():
	var smallest_x = INF  # Initialize to a very large number
	var largest_x = -INF  # Initialize to a very small number
	var smallest_y = INF  # Initialize to a very large number
	var largest_y = -INF  # Initialize to a very small number

	# Loop through all tiles in the TileMap
	for cell in tile_map.get_used_cells(0):  # Assuming layer 0
		var cell_x = cell.x
		var cell_y = cell.y

		# Check for smallest and largest X
		if cell_x < smallest_x:
			smallest_x = cell_x
		if cell_x > largest_x:
			largest_x = cell_x

		# Check for smallest and largest Y
		if cell_y < smallest_y:
			smallest_y = cell_y
		if cell_y > largest_y:
			largest_y = cell_y

	var rand_height_s = randi_range(smallest_y, largest_y)
	var rand_height_f = randi_range(smallest_y, largest_y)
	
	

	tile_map.set_cell(0, Vector2i(smallest_x, rand_height_s), 1, Vector2i(0,0))
	tile_map.set_cell(0, Vector2i(largest_x, rand_height_f), 1, Vector2i(0,0))
	
	var instance = castleScene.instantiate()
	add_child(instance)
	instance.position = tile_map.map_to_local(Vector2i(largest_x, rand_height_f))
	
	var portal_instance = portalScene.instantiate()
	add_child(portal_instance)
	portal_instance.position = tile_map.map_to_local(Vector2i(smallest_x, rand_height_s))
	
	
	
	# Create three points between start and finish 
	var diff = largest_x - smallest_x
	var diff_m = round(diff/6)
	
	last_point = Vector2(smallest_x, rand_height_s)
	finish_point = Vector2(largest_x, rand_height_f)
	
	for i in range(1, 7):
		var rand_height_p = randi_range(smallest_y, largest_y)
		tile_map.set_cell(0, Vector2i(diff_m*i, rand_height_p), 0, Vector2i(0,0))
		draw_path(Vector2i(diff_m*i, rand_height_p))
		
	draw_path(finish_point)
	draw_buttons()
	tile_map.bake_map()

func draw_path(point):
	var distance_x = point.x - last_point.x
	var distance_y = point.y - last_point.y

	# Draw along the X axis
	if distance_x != 0:
		for x in range(abs(distance_x) + 1):  # +1 to include the final point
			var step_x = last_point.x + x if distance_x > 0 else last_point.x - x
			tile_map.set_cell(0, Vector2i(step_x, last_point.y), 1, Vector2i(0, 0))

	# Draw along the Y axis
	if distance_y > 0:
		for y in range(distance_y + 1):  # +1 to include the final point
			tile_map.set_cell(0, Vector2i(point.x, last_point.y + y), 1, Vector2i(0, 0))
	elif distance_y < 0:
		for y in range(abs(distance_y) + 1):  # +1 to include the final point
			tile_map.set_cell(0, Vector2i(point.x, last_point.y - y), 1, Vector2i(0, 0))

	# Update the last_point for the next path segment
	last_point = point

func draw_buttons():
	templateButton.visible = false
	var counter = 0
	for tower in towerList.towerTypes:
		var newButton = Button.new()
		newButton.icon = tower.mainSprite
		newButton.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		newButton.position.y = templateButton.position.y
		newButton.position.x = templateButton.position.x + (counter * 120)
		newButton.pressed.connect(self.passBuildingTower.bind(tower))
		newButton.size.x = templateButton.size.x
		newButton.size.y = templateButton.size.y
		newButton.theme = theme
		newButton.mouse_entered.connect(self.showtooltip.bind(tower, newButton))
		newButton.mouse_exited.connect(self.hidetooltip.bind(tower))
		
		$CanvasLayer/ButtonContainer.add_child(newButton)
		counter += 1


func showtooltip(type, btn):
	tooltip_header.set_text('[center]' + type.towerName + '[/center]')
	tooltip_price.set_text('[center]Price: ' + str(type.cost) + '[/center]')
	tooltip_desc.set_text('[center]' + type.description + '[/center]')
	tooltip.global_position.x = btn.global_position.x - 30
	tooltip.visible = true
	
func hidetooltip(type):
	tooltip.visible = false

func passBuildingTower(type):
	buildingManager.startBuildingTower(type)


func _on_button_2_pressed():
	portal.startWave()
	$CanvasLayer/Button2.visible = false
