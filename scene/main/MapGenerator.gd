extends Node

signal tile_placed(groupName, x, y, x_offset, y_offset)
signal map_finished(map)

const MAX_X = DungeonSize.MAX_X
const MAX_Y = DungeonSize.MAX_Y

var _entropy_lookup = {
	1 : [], 2 : [], 3 : [], 4 : [], 5 : [], 6 : [], 7 : [], 8 : [],
	9 : [], 10 : [], 11 : []
}

var _potential_tiles : Array
var _final_tiles : Array

var rng = RandomNumberGenerator.new()

func _ready():
	var _tile_map = {}
	for tile_name in TileTypes.mapTileNames:
		_tile_map[tile_name] = true

	for i in range(MAX_X * MAX_Y):
		_potential_tiles.append(_tile_map.duplicate(true))

	for i in range(MAX_X * MAX_Y):
		_final_tiles.append("failed")

	for i in range(MAX_X):
		for j in range(MAX_Y):
			_entropy_lookup[11].append(Vector2i(i, j))

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

func _get_legal_tiles(pos : Vector2i) -> Array:
	var legal_tiles = []
	for key in _get_tile_list(pos):
		if _get_tile_list(pos)[key]:
			legal_tiles.append(key)
	return legal_tiles

func _remove_illegal_tiles(pos : Vector2i, illegal_tiles : Array): 
	for t in illegal_tiles:
		_get_tile_list(pos)[t] = false


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
	emit_signal("map_finished", _final_tiles)

func _get_low_entropy_pos() -> Vector2i:
	for k in _entropy_lookup:
		if not _entropy_lookup[k].is_empty():
			var ind = rng.randi_range(0, _entropy_lookup[k].size() - 1)
			return _entropy_lookup[k].pop_at(ind)
	return Vector2i(-1, -1)

func _is_empty(d : Dictionary) -> bool:
	for k in d:
		if not d[k].is_empty():
			return false
	return true

func _generate_map():
		while not _is_empty(_entropy_lookup):
			var random_pos = _get_low_entropy_pos()
			var random_tile : String
			if _get_legal_tiles(random_pos):
				random_tile = _get_legal_tiles(random_pos).pick_random()
			if random_tile:
				_final_tiles[random_pos.x + random_pos.y * MAX_Y] = random_tile
				_update_neighbors(random_pos, TileRules.TileRule[random_tile])
