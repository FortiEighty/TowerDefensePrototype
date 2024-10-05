extends TileMap

var astar = AStarGrid2D.new()
var map_rect = Rect2i()

func bake_map():
	
	var tilemap_size = get_used_rect().end - get_used_rect().position
	map_rect = Rect2i(Vector2i.ZERO, tilemap_size)
	
	var tile_size = get_tileset().tile_size
	
	astar.region = map_rect
	astar.cell_size = tile_size
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()

	for i in tilemap_size.x:
		for j in tilemap_size.y:
			var coords = Vector2i(i, j)
			var tile_data = get_cell_tile_data(0, coords)
			if tile_data and tile_data.get_custom_data('walkable') == 'no':
				astar.set_point_solid(coords)
			if tile_data and tile_data.get_custom_data('walkable') == 'yes':
				astar.set_point_weight_scale(coords, 150)

func is_point_walkable(pos):
	var map_position = local_to_map(pos)
	if map_rect.has_point(map_position) and not astar.is_point_solid(map_position):
		return true
	return false

func update_weights(s_pos, e_pos):
	var tiles_amount = (s_pos.distance_to(e_pos))
	var tiles_direction = (s_pos.direction_to(e_pos))
	var direction_x = round(tiles_direction.x)
	var direction_y = round(tiles_direction.y)
	for i in tiles_amount: 
		astar.set_point_weight_scale(Vector2(s_pos.x+(direction_x*i), s_pos.y+(direction_y*i)), 1)
		
func set_unwalkable_point(s_pos, e_pos):
	for x in range(s_pos.x, e_pos.x):
		for y in range(s_pos.y, e_pos.y):
			astar.set_point_solid(Vector2i(x, y))

func set_cell_unwalkable(cell):
	astar.set_point_solid(cell)
