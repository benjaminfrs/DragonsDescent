extends Node

signal tile_placed(groupName, x, y, x_offset, y_offset)
signal map_finished(map)

var _new_DungeonSize
var _new_GroupName

var _arr : Array
var _potential_tiles : Array
var _arrTest : Array
var _testing : Array
var _finalTiles : Array

const mapTileNames: Array = ["1", "2", "3"]

var rng = RandomNumberGenerator.new()

func _vec2i_in_bounds(v: Vector2i):
	if v.x < 0 or v.x >= _new_DungeonSize.MAX_X:
		return false
	if v.y < 0 or v.y >= _new_DungeonSize.MAX_Y:
		return false
	return true

func _get_entropy(pos : Vector2i) -> int:
	return _get_legal_tiles(pos).size()

func _get_tile_list(pos : Vector2i) -> Dictionary:
	return _potential_tiles[pos.x + pos.y * _new_DungeonSize.MAX_Y]

func _get_legal_tiles(pos : Vector2i) -> Array:
	var legal_tiles = []
	#print(pos, _get_tile_list(pos))
	for key in _get_tile_list(pos):
		if _get_tile_list(pos)[key]:
			legal_tiles.append(key)
	return legal_tiles


func _remove_illegal_tiles(pos : Vector2i, illegal_tiles : Array): 
	for t in illegal_tiles:
		#print(_get_tile_list(pos))
		_get_tile_list(pos)[t] = false


func _update_neighbors(tile_pos : Vector2i, tile_name : String, tile_rule : Dictionary):
	#print(tile_rule)
	for dir in tile_rule.keys():
		#print(dir)
		var neighbor_pos = tile_pos + TileRules.Directions[dir]
		if _vec2i_in_bounds(neighbor_pos):
			#for illegal_neighbors in tile_rule[dir]:
			#print(neighbor_pos," ",dir, " ", tile_name, " before filter tiles", _get_legal_tiles(neighbor_pos))
			_remove_illegal_tiles(neighbor_pos, tile_rule[dir])
			#print(neighbor_pos, " ", dir, " ", tile_name, " after filter tiles", _get_legal_tiles(neighbor_pos))


func _on_Main_game_ready():
	var _tile_map = {}
	for tile_name in TileTypes.mapTileNames:
		_tile_map[tile_name] = true
		#print("tile init", _tile_map[tile_name])

	#_potential_tiles.resize(_new_DungeonSize.MAX_X * _new_DungeonSize.MAX_Y)
	for i in range(_new_DungeonSize.MAX_X * _new_DungeonSize.MAX_X):
		_potential_tiles.append(_tile_map.duplicate(true))
	#_potential_tiles.fill(_tile_map.duplicate(true))

	#_finalTiles.resize(_new_DungeonSize.MAX_X * _new_DungeonSize.MAX_Y)
	#_finalTiles.fill(0)
	for i in range(_new_DungeonSize.MAX_X * _new_DungeonSize.MAX_X):
		_finalTiles.append("failed")
	_generate_map()
	emit_signal("map_finished", _finalTiles)

func _generate_map():
	for i in range(_new_DungeonSize.MAX_X):
		for j in range(_new_DungeonSize.MAX_Y):
			#print("legal tiles ", Vector2i(i, j), _get_legal_tiles(Vector2i(i, j)))
			var random_tile = _get_legal_tiles(Vector2i(i, j)).pick_random()
			if random_tile:
				print("placing: ", random_tile, " ", i + j*_new_DungeonSize.MAX_Y, " ", Vector2i(i,j))
				_update_neighbors(Vector2i(i, j), random_tile, TileRules.TileRule[random_tile])
				_finalTiles[i + j * _new_DungeonSize.MAX_Y] = random_tile
				#emit_signal("tile_placed", _finalTiles[i + j * _new_DungeonSize.MAX_Y], i, j)
	#print(_finalTiles)
#func _on_Main_game_ready():
#	_finalTiles.resize(_new_DungeonSize.MAX_X * _new_DungeonSize.MAX_Y)
#	_finalTiles.fill(0)
#
#	for v in _new_GroupName.mapTileNames:
#		_arrTest.append(v)
#	#print(_arrTest, _arrTest.is_read_only())
#
#	_arr.resize(_new_DungeonSize.MAX_X * _new_DungeonSize.MAX_Y)
#	for i in range(_new_DungeonSize.MAX_X * _new_DungeonSize.MAX_Y):
#		_arr[i] = _arrTest.duplicate(true)
#	#_arr.fill(Array(_arrTest))
#	print(_arr)
#	
#	#mapTileNames.erase("1")
#	#print(typeof(mapTileNames))
#	#var tmp = Array(mapTileNames)
#	#t#mp.erase("1")
#	
#	
#	#print("before erase", _arrTest)
#	#_arrTest.erase(_new_GroupName.DWARF)
#	#print("after erase", _arrTest)
#	
#	_generate_map()
#	#print(_arr)
#	#print(_finalTiles)

#func _generate_map():
#	#var _first: bool = true
#	for i in range(_new_DungeonSize.MAX_X):
#		for j in range(_new_DungeonSize.MAX_Y):
#			_set_tile_at_pos(i, j)
#				
#func _set_tile_at_pos(x: int, y: int):
#	print(x, " ", y, " ", x + y * _new_DungeonSize.MAX_Y, " ", _arr[x + y * _new_DungeonSize.MAX_Y])
#	var tileInd: int = rng.randi_range(0, (_arr[x + y * _new_DungeonSize.MAX_Y].size() - 1))
#	print("tileInd", tileInd)
#	_finalTiles[x + y * _new_DungeonSize.MAX_Y] = _arr[x + y * _new_DungeonSize.MAX_Y][tileInd]
#	emit_signal("tile_placed", _finalTiles[x + y * _new_DungeonSize.MAX_Y], x, y)
#	var tileCall: String = "_update_" + _arr[x + y * _new_DungeonSize.MAX_Y][tileInd] + "_neighbors"
#	#print(tileCall)
#	self.call(tileCall, x, y)
#
#func _update_floor_neighbors(x: int, y: int):
#	pass
#
#func _update_dwarf_neighbors(x: int, y: int):
#	for i in range(x - 3, x + 3):
#		for j in range(y - 3, y + 3):
#			if idxs_in_bounds(i, j):
#				_arr[i + j * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#
#func _update_bewall_neighbors(x: int, y: int):
#  #start bottom row tile filtering
#	if idxs_in_bounds(x - 1, y - 1):
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x, y - 1):
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x + 1, y - 1):
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#  #end bottom row tile filtering
#
#  #start top row tile filtering
#	if idxs_in_bounds(x - 1, y + 1):
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#
#	if idxs_in_bounds(x, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#
#	if idxs_in_bounds(x + 1, y + 1):
#		print("x + 1, y + 1")
#		print(_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y])
#		print("finding ", _arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].find(_new_GroupName.BLWALL))
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		#_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase("dwarf")
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		print("after", _arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y])
#
#  #end top row tile filtering
#  #start middle row tile filtering
#	if idxs_in_bounds(x - 1, y):
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x + 1, y):
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#  #end middle row tile filtering
#
#func _update_uewall_neighbors(x: int, y: int):
#  #start bottom row tile filtering
#	if idxs_in_bounds(x - 1, y - 1):
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x, y - 1):
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#
#	if idxs_in_bounds(x + 1, y - 1):
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#  #end bottom row tile filtering
#  #start top row tile filtering
#	if idxs_in_bounds(x - 1, y + 1):
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x + 1, y + 1):
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#  #end top row tile filtering
#  #start middle row tile filtering
#	if idxs_in_bounds(x - 1, y):
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#
#	if idxs_in_bounds(x + 1, y):
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#
#  #end middle row tile filtering
#func _update_lewall_neighbors(x: int, y: int):
#  #start bottom row tile filtering
#	if idxs_in_bounds(x - 1, y - 1):
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#
#	if idxs_in_bounds(x, y - 1):
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x + 1, y - 1):
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#  #end bottom row tile filtering
#  #start top row tile filtering
#	if idxs_in_bounds(x - 1, y + 1):
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x + 1, y + 1):
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#  #end top row tile filtering
#  #start middle row tile filtering
#	if idxs_in_bounds(x - 1, y):
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x + 1, y):
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#  #end middle row tile filtering
#func _update_rewall_neighbors(x: int, y: int):
#  #start bottom row tile filtering
#	if idxs_in_bounds(x - 1, y - 1):
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x, y - 1):
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x + 1, y - 1):
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#
#  #end bottom row tile filtering
#  #start top row tile filtering
#	if idxs_in_bounds(x - 1, y + 1):
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#
#	if idxs_in_bounds(x, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x + 1, y + 1):
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#  #end top row tile filtering
#  #start middle row tile filtering
#	if idxs_in_bounds(x - 1, y):
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x + 1, y):
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#  #end middle row tile filtering
#
#
#func _update_wall_neighbors(x: int, y: int):
#  #start bottom row tile filtering
#	if idxs_in_bounds(x - 1, y - 1):
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#
#	if idxs_in_bounds(x, y - 1):
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#
#	if idxs_in_bounds(x + 1, y - 1):
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#  #end bottom row tile filtering
#
#  #start top row tile filtering
#	if idxs_in_bounds(x, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#
#	if idxs_in_bounds(x - 1, y + 1):
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x - 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#
#	if idxs_in_bounds(x + 1, y + 1):
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x + 1) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#  #end top row tile filtering
#
#  #start middle row tile filtering
#	if idxs_in_bounds(x + 1, y):
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#
#	if idxs_in_bounds(x - 1, y):
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#  #end middle row tile filtering
#
#func _update_ulwall_neighbors(x: int, y: int):
#  #start bottom row tile filtering
#	if idxs_in_bounds(x - 1, y - 1):
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#
#	if idxs_in_bounds(x, y - 1):
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#
#	if idxs_in_bounds(x + 1, y - 1):
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#  #end bottom row tile filtering
#
#  #start top row tile filtering
#	if idxs_in_bounds(x, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x - 1, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x + 1, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#  #end top row tile filtering
#
#  #start middle row tile filtering
#	if idxs_in_bounds(x + 1, y):
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#
#	if idxs_in_bounds(x - 1, y):
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#
#func _update_blwall_neighbors(x: int, y: int):
#  #start bottom row tile filtering
#	if idxs_in_bounds(x - 1, y - 1):
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#
#	if idxs_in_bounds(x, y - 1):
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#
#	if idxs_in_bounds(x + 1, y - 1):
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#  #end bottom row tile filtering
#
#  #start top row tile filtering
#	if idxs_in_bounds(x, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#
#	if idxs_in_bounds(x - 1, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x + 1, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#  #end top row tile filtering
#
#  #start middle row tile filtering
#	if idxs_in_bounds(x + 1, y):
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#
#	if idxs_in_bounds(x - 1, y):
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#
#
#func _update_urwall_neighbors(x: int, y: int):
#  #start bottom row tile filtering
#	if idxs_in_bounds(x - 1, y - 1):
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#
#	if idxs_in_bounds(x, y - 1):
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#
#	if idxs_in_bounds(x + 1, y - 1):
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#  #end bottom row tile filtering
#
#  #start top row tile filtering
#	if idxs_in_bounds(x, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#
#	if idxs_in_bounds(x - 1, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#
#	if idxs_in_bounds(x + 1, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#  #end top row tile filtering
#
#  #start middle row tile filtering
#	if idxs_in_bounds(x + 1, y):
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#
#	if idxs_in_bounds(x - 1, y):
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#  #end middle row tile filtering
#
#
#func _update_brwall_neighbors(x: int, y: int):
#  #start bottom row tile filtering
#	if idxs_in_bounds(x - 1, y - 1):
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x - 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#
#	if idxs_in_bounds(x, y - 1):
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#
#	if idxs_in_bounds(x + 1, y - 1):
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y - 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#  #end bottom row tile filtering
#
#  #start top row tile filtering
#	if idxs_in_bounds(x, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#
#	if idxs_in_bounds(x - 1, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#
#	if idxs_in_bounds(x + 1, y + 1):
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x) + (y + 1) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#  #end top row tile filtering
#
#  #start middle row tile filtering
#	if idxs_in_bounds(x + 1, y):
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BLWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x + 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BEWALL)
#
#	if idxs_in_bounds(x - 1, y):
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.WALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.BRWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.URWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.ULWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.REWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.LEWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.UEWALL)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.DWARF)
#		_arr[(x - 1) + (y) * _new_DungeonSize.MAX_Y].erase(_new_GroupName.FLOOR)
#
#func idxs_in_bounds(x: int, y: int):
#	if x < 0 or x >= _new_DungeonSize.MAX_X:
#		return false
#	if y < 0 or y >= _new_DungeonSize.MAX_Y:
#		return false
#	return true
