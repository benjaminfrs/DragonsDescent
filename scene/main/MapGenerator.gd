extends Node

signal tile_placed(groupName, x, y, x_offset, y_offset)
signal map_finished(map)

const MAX_X = DungeonSize.MAX_X
const MAX_Y = DungeonSize.MAX_Y

var _entropy_lookup = {
	1 : [], 2 : [], 3 : [], 4 : [], 5 : [], 6 : [], 7 : [], 8 : [],
	9 : [], 10 : []
}

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

	for i in range(MAX_X):
		for j in range(MAX_Y):
			_entropy_lookup[10].append(Vector2i(i, j))

func _vec2i_in_bounds(v: Vector2i):
	if v.x < 0 or v.x >= MAX_X:
		return false
	if v.y < 0 or v.y >= MAX_Y:
		return false
	return true

func _get_entropy(pos : Vector2i) -> int:
	return _get_legal_tiles(pos).size()

func _get_tile_list(pos : Vector2i) -> Dictionary:
	return _potential_tiles[pos.x + pos.y * MAX_Y]

#func _get_legal_tiles(pos : Vector2i) -> Array:
#	var legal_tiles = []
#	for key in _get_tile_list(pos):
#		if _get_tile_list(pos)[key]:
#			legal_tiles.append(key)
#	return legal_tiles
func _get_legal_tiles(pos : Vector2i) -> Array:
	return _potential_tiles[pos.x + pos.y * MAX_Y]

#func _remove_illegal_tiles(pos : Vector2i, illegal_tiles : Array): 
#	for t in illegal_tiles:
#		_get_tile_list(pos)[t] = false
func _remove_illegal_tiles(pos : Vector2i, illegal_tiles : Array):
	#print(pos, "before: ", _get_legal_tiles(pos))
	for t in illegal_tiles:
		_get_legal_tiles(pos).erase(t)
	#print(pos, "after: ", _get_legal_tiles(pos))

func _get_valid_dirs(pos : Vector2i) -> Array:
	var dirs = []
	
	for d in TileRules.Directions:
		if _vec2i_in_bounds(pos + TileRules.Directions[d]):
			dirs.append(d)
	return dirs

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
		
		for d in _get_valid_dirs(cur_pos):
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
			#for t1 in _get_legal_tiles(cur_pos):
			#	var incompatible_tiles = []
				#for t2 in _get_legal_tiles(tile_to_update_pos):
				#	if not _tiles_are_compatable(t1, t2, d):
				#		incompatible_tiles.append(t2)
				#		compatible = false
				
			_remove_illegal_tiles(tile_to_update_pos, incompatible_tiles)

func _update_neighbors(tile_pos : Vector2i, tile_rule : Dictionary):
	for dir in tile_rule.keys():
		var neighbor_pos = tile_pos + TileRules.Directions[dir]
		if _vec2i_in_bounds(neighbor_pos) and _final_tiles[neighbor_pos.x + neighbor_pos.y * MAX_Y] == "failed":
			if _get_entropy(neighbor_pos):
				_entropy_lookup[_get_entropy(neighbor_pos)].erase(neighbor_pos)
			_remove_illegal_tiles(neighbor_pos, tile_rule[dir])
			if _get_entropy(neighbor_pos):
				_entropy_lookup[_get_entropy(neighbor_pos)].append(neighbor_pos)


func _on_Main_game_ready():
	_generate_map()
	#for i in range(MAX_X):
	#	for j in range(MAX_Y):
	#		if _final_tiles[i + j * MAX_Y] == "failed":
	#			_final_tiles[i + j * MAX_Y] = "wall"
	emit_signal("map_finished", _get_fully_collapsed())

func _get_shannon_entropy(pos : Vector2i) -> float:
	var sum_of_weights = 0
	var sum_of_weight_log_weights = 0
	
	for tile in _potential_tiles[pos.x + pos.y * MAX_Y]:
		var weight = TileTypes.basic_tile_weights[tile]
		sum_of_weights += weight
		sum_of_weight_log_weights +=  weight * log(weight)
	return log(sum_of_weights) - (sum_of_weight_log_weights / sum_of_weights)

func _get_low_entropy_pos_test() -> Vector2i:
	for k in _entropy_lookup:
		if not _entropy_lookup[k].is_empty():
			var ind = rng.randi_range(0, _entropy_lookup[k].size() - 1)
			return _entropy_lookup[k].pop_at(ind)
	return Vector2i(-1, -1)
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
	#print(legal_tiles)
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
		#while not _is_empty(_entropy_lookup):
		while not _is_fully_collapsed():
			#var random_pos = _get_low_entropy_pos()
			var random_pos = _get_low_entropy_pos()
			var random_tile : String
			if _get_legal_tiles(random_pos):
				random_tile = _collapse(random_pos)
				#print(random_pos, random_tile)
			if random_tile:
				_potential_tiles[random_pos.x + random_pos.y * MAX_Y] = [random_tile]
				#_final_tiles[random_pos.x + random_pos.y * MAX_Y] = random_tile
				#emit_signal("tile_placed", random_tile, random_pos.x, random_pos.y)
				#_update_neighbors(random_pos, TileRules.TileRule[random_tile])
				_propagate_tile_rules(random_pos)
