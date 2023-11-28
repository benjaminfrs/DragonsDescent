extends Node

#signal tile_placed(groupName, x, y, x_offset, y_offset)
signal map_finished(map)

const MAX_X = DungeonSize.MAX_X
const MAX_Y = DungeonSize.MAX_Y

var _potential_tiles : Array
var _final_tiles : Array

var rng = RandomNumberGenerator.new()

func _generate_tile_matrix(max_x : int, max_y : int, possible_tiles : Array) -> Array:
	var matrix = []
	for i in range(max_x * max_y):
		matrix.append(possible_tiles.duplicate(true))
	return matrix

func _ready():
	_potential_tiles = _generate_tile_matrix(MAX_X, MAX_Y, TileTypes.basic_tiles)

	for i in range(MAX_X * MAX_Y):
		_final_tiles.append("failed")

func _get_legal_tiles(pos : Vector2i) -> Array:
	return _potential_tiles[pos.x + pos.y * MAX_Y]

func _remove_illegal_tiles(pos : Vector2i, illegal_tiles : Array):
	for t in illegal_tiles:
		_get_legal_tiles(pos).erase(t)

func _tiles_are_compatable(t1 : String, t2 : String, dir : String) -> bool:
	if TileRules.TileRule[t1][dir].find(t2) >= 0:
		return false
	return true

func _propagate_tile_rules(pos : Vector2i):
	var stack = [pos]
	
	while stack.size() > 0:
		#print("stack: ", stack)
		var cur_pos = stack.pop_front()
		var legal_tiles = _get_legal_tiles(cur_pos)
		#print(cur_pos, " - propagating from this tile - legal tiles: ", legal_tiles,)
		
		for d in DungeonSize.get_valid_dirs(cur_pos):
			var tile_to_update_pos = cur_pos + TileRules.Directions[d]
			var incompatible_tiles = []
			for other_tile in _get_legal_tiles(tile_to_update_pos):
				var compatible = false
				for cur_tile in _get_legal_tiles(cur_pos):
					if _tiles_are_compatable(cur_tile, other_tile, d):
						compatible = true
				if not compatible:
					incompatible_tiles.append(other_tile)
					stack.append(tile_to_update_pos)
			_remove_illegal_tiles(tile_to_update_pos, incompatible_tiles)


func _on_Main_game_ready():
	_generate_map()
	emit_signal("map_finished", _get_fully_collapsed())

func _get_shannon_entropy(pos : Vector2i) -> float:
	var sum_of_weights = 0
	var sum_of_weight_log_weights = 0
	
	for tile in _potential_tiles[pos.x + pos.y * MAX_Y]:
		var weight = TileTypes.basic_tile_weights[tile]
		sum_of_weights += weight
		sum_of_weight_log_weights +=  weight * log(weight)
	return log(sum_of_weights) - (sum_of_weight_log_weights / sum_of_weights)

func _get_low_entropy_pos() -> Vector2i:
	var min_entropy : float
	var min_entropy_pos = Vector2i(0,0)
	for i in range(MAX_X):
		for j in range(MAX_Y):
			if _get_legal_tiles(Vector2i(i, j)).size() == 1:
				continue
			var entropy = _get_shannon_entropy(Vector2i(i, j))
			var entropy_with_noise = entropy - (rng.randf() / 1000)
			if not min_entropy or entropy_with_noise < min_entropy:
				min_entropy = entropy_with_noise
				min_entropy_pos = Vector2i(i, j)
	return min_entropy_pos


func _is_empty(d : Dictionary) -> bool:
	for k in d:
		if not d[k].is_empty():
			return false
	return true

func _get_total_weight(legal_tiles : Array) -> float:
	var total_weight = 0.0
	for t in legal_tiles:
		total_weight += TileTypes.basic_tile_weights[t]
	return total_weight

func _collapse(pos : Vector2i) -> String:
	var legal_tiles = _get_legal_tiles(pos)
	var rnd = rng.randf() * _get_total_weight(legal_tiles)
	var chosen_tile = legal_tiles[0]
	for t in legal_tiles:
		rnd -= TileTypes.basic_tile_weights[t]
		if rnd < 0:
			return t
	return chosen_tile

func _is_fully_collapsed() -> bool:
	for tile in _potential_tiles:
		if tile.size() > 1:
			return false
	return true

func _get_fully_collapsed() -> Array:
	var res = []
	for tile in _potential_tiles:
		res.append(tile[0])
	return res

func _generate_map():
		while not _is_fully_collapsed():
			var random_pos = _get_low_entropy_pos()
			#print(_get_legal_tiles(random_pos).size())
			var random_tile = _collapse(random_pos)
			_potential_tiles[random_pos.x + random_pos.y * MAX_Y] = [random_tile]
			_propagate_tile_rules(random_pos)
			print(random_pos, random_tile)
			var _a = _get_fully_collapsed()
