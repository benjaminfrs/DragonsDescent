extends Node

signal map_finished(map)

const MAX_X = DungeonSize.MAX_X
const MAX_Y = DungeonSize.MAX_Y

var rng = RandomNumberGenerator.new()

func _generate_tile_matrix(max_x : int, max_y : int, possible_tiles : Array) -> Array:
	var matrix = []
	for i in range(max_x * max_y):
		matrix.append(possible_tiles.duplicate(true))
	return matrix

func _get_legal_tiles(pos : Vector2i, tile_matrix : Array) -> Array:
	return tile_matrix[pos.x + pos.y * MAX_Y]

func _remove_illegal_tiles(pos : Vector2i, illegal_tiles : Array, tile_matrix : Array):
	for t in illegal_tiles:
		_get_legal_tiles(pos, tile_matrix).erase(t)

func _tiles_are_compatable(t1 : String, t2 : String, dir : String) -> bool:
	if TileRules.TileRule[t1][dir].find(t2) >= 0:
		return false
	return true

func _propagate_tile_rules(pos : Vector2i, tile_matrix : Array):
	var stack = [pos]
	
	while stack.size() > 0:
		#print("stack: ", stack)
		var cur_pos = stack.pop_front()
		var legal_tiles = _get_legal_tiles(cur_pos, tile_matrix)
		#print(cur_pos, " - propagating from this tile - legal tiles: ", legal_tiles,)
		
		for d in DungeonSize.get_valid_dirs(cur_pos):
			var tile_to_update_pos = cur_pos + TileRules.Directions[d]
			var incompatible_tiles = []
			for other_tile in _get_legal_tiles(tile_to_update_pos, tile_matrix):
				var compatible = false
				for cur_tile in _get_legal_tiles(cur_pos, tile_matrix):
					if _tiles_are_compatable(cur_tile, other_tile, d):
						compatible = true
				if not compatible:
					incompatible_tiles.append(other_tile)
					stack.append(tile_to_update_pos)
			_remove_illegal_tiles(tile_to_update_pos, incompatible_tiles, tile_matrix)


func _on_Main_game_ready():
	pass
	#emit_signal("map_finished", generate())

func generate() -> Array:
	var tile_matrix : Array
	tile_matrix = _generate_tile_matrix(MAX_X, MAX_Y, TileTypes.basic_tiles)
	_generate_map(tile_matrix)
	return _get_fully_collapsed(tile_matrix)

func _get_shannon_entropy(pos : Vector2i, tile_matrix : Array) -> float:
	var sum_of_weights = 0
	var sum_of_weight_log_weights = 0
	
	for tile in _get_legal_tiles(pos, tile_matrix):
		var weight = TileTypes.basic_tile_weights[tile]
		sum_of_weights += weight
		sum_of_weight_log_weights +=  weight * log(weight)
	return log(sum_of_weights) - (sum_of_weight_log_weights / sum_of_weights)

func _get_low_entropy_pos(tile_matrix : Array) -> Vector2i:
	var min_entropy : float
	var min_entropy_pos = Vector2i(0,0)
	for i in range(MAX_X):
		for j in range(MAX_Y):
			if _get_legal_tiles(Vector2i(i, j), tile_matrix).size() == 1:
				continue
			var entropy = _get_shannon_entropy(Vector2i(i, j), tile_matrix)
			var entropy_with_noise = entropy - (rng.randf() / 1000)
			if not min_entropy or entropy_with_noise < min_entropy:
				min_entropy = entropy_with_noise
				min_entropy_pos = Vector2i(i, j)
	return min_entropy_pos

func _get_total_weight(legal_tiles : Array) -> float:
	var total_weight = 0.0
	for t in legal_tiles:
		total_weight += TileTypes.basic_tile_weights[t]
	return total_weight

func _collapse(pos : Vector2i, tile_matrix : Array) -> String:
	var legal_tiles = _get_legal_tiles(pos, tile_matrix)
	var rnd = rng.randf() * _get_total_weight(legal_tiles)
	var chosen_tile = legal_tiles[0]
	for t in legal_tiles:
		rnd -= TileTypes.basic_tile_weights[t]
		if rnd < 0:
			return t
	return chosen_tile

func _is_fully_collapsed(tile_matrix : Array) -> bool:
	for tile in tile_matrix:
		if tile.size() > 1:
			return false
	return true

func _get_fully_collapsed(tile_matrix : Array) -> Array:
	var res = []
	for tile in tile_matrix:
		res.append(tile[0])
	return res

func _generate_map(tile_matrix : Array):
		while not _is_fully_collapsed(tile_matrix):
			var random_pos = _get_low_entropy_pos(tile_matrix)
			tile_matrix[random_pos.x + random_pos.y * MAX_Y] = [_collapse(random_pos, tile_matrix)]
			_propagate_tile_rules(random_pos, tile_matrix)
