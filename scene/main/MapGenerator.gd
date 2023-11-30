extends Node

signal map_finished(map)

const MAX_X = DungeonSize.MAX_X
const MAX_Y = DungeonSize.MAX_Y

var rng = RandomNumberGenerator.new()

func _generate_tile_matrix(max_x : int, max_y : int, possible_tiles : Array) -> Dictionary:
	var matrix = {}
	for x in range(max_x):
		for y in range(max_y):
			var pos = Vector2i(x, y)
			matrix[pos] = possible_tiles.duplicate(true)
		#matrix.append(possible_tiles.duplicate(true))
	return matrix

func _get_legal_tiles(pos : Vector2i, tile_matrix : Dictionary) -> Array:
	return tile_matrix[pos]

func _remove_illegal_tiles(pos : Vector2i, illegal_tiles : Array, tile_matrix : Dictionary):
	var temp = tile_matrix[pos].duplicate(true)
	for t in illegal_tiles:
		_get_legal_tiles(pos, tile_matrix).erase(t)
	if tile_matrix[pos].size() == 0:
		print(pos)
		print(illegal_tiles)
		print(temp)

func _tiles_are_compatable(t1 : String, t2 : String, dir : String) -> bool:
	if not t1:
		return false
	if TileRules.TileRule[t1][dir].find(t2) >= 0:
		return false
	return true

func _propagate_tile_rules(pos : Vector2i, tile_matrix : Dictionary):
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

func generate() -> Dictionary:
	var tile_matrix = {}
	tile_matrix = _generate_tile_matrix(MAX_X, MAX_Y, TileTypes.basic_tiles)
	_generate_map(tile_matrix)
	#return _get_fully_collapsed(tile_matrix)
	return tile_matrix

func _get_shannon_entropy(pos : Vector2i, tile_matrix : Dictionary) -> float:
	var sum_of_weights = 0
	var sum_of_weight_log_weights = 0
	
	for tile in _get_legal_tiles(pos, tile_matrix):
		var weight = TileTypes.basic_tile_weights[tile]
		sum_of_weights += weight
		sum_of_weight_log_weights +=  weight * log(weight)
	return log(sum_of_weights) - (sum_of_weight_log_weights / sum_of_weights)

func _get_low_entropy_pos(tile_matrix : Dictionary) -> Vector2i:
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

func _collapse(pos : Vector2i, tile_matrix : Dictionary) -> String:
	var legal_tiles = _get_legal_tiles(pos, tile_matrix)
	var rnd = rng.randf() * _get_total_weight(legal_tiles)
	var chosen_tile = legal_tiles[0]
	for t in legal_tiles:
		rnd -= TileTypes.basic_tile_weights[t]
		if rnd < 0:
			return t
	return chosen_tile

func _is_fully_collapsed(tile_matrix : Dictionary) -> bool:
	#print(tile_matrix)
	for tile in tile_matrix.values():
		if not tile.size() == 1:
			return false
	return true

#func _get_fully_collapsed(tile_matrix : Dictionary) -> Array:
#	var res = []
#	for tile in tile_matrix.values():
#		res.append(tile[0])
#	return res

func _generate_map(tile_matrix : Dictionary):
		while not _is_fully_collapsed(tile_matrix):
			var random_pos = _get_low_entropy_pos(tile_matrix)
			var random_tile = _collapse(random_pos, tile_matrix)
			#print(random_tile)
			tile_matrix[random_pos] = [random_tile]
			_propagate_tile_rules(random_pos, tile_matrix)
