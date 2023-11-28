extends Node2D

signal illegal_move(message)
signal sprite_removed(pos, sprite)

var _ref_InitWorld

const Floor := preload("res://sprite/floor_sprite.tscn")

var _arr : Array
var _pc_ref
var _astargrid : AStarGrid2D

func _on_Main_game_ready():
	_arr.resize(DungeonSize.MAX_X * DungeonSize.MAX_Y)
	
	_astargrid = AStarGrid2D.new()
	_astargrid.size = Vector2i(DungeonSize.MAX_X, DungeonSize.MAX_Y)
	_astargrid.cell_size = Vector2i(ConvertCoords.STEP_X, ConvertCoords.STEP_Y)
	_astargrid.update()

func get_pc_pos() -> Vector2i:
	return ConvertCoords.get_world_coords(_pc_ref.position)

func get_astar_path(a : Vector2i, b : Vector2i) -> Array:
	return _astargrid.get_id_path(a, b)

func is_legal_move(pos : Vector2i) -> bool:
	if not DungeonSize.is_inside_dungeon(pos):
		emit_signal("illegal_move", "You cannot leave the dungeon >:D")
		return false
	if tile_type_fuzzy_search(pos, "wall"):
		emit_signal("illegal_move", "You cannot move through walls...yet")
		return false
	return true

func get_neighbors(pos : Vector2i) -> Array:
	var neighbors = []
	for d in DungeonSize.get_valid_dirs(pos):
		neighbors.append(pos + TileRules.Directions[d])
	return neighbors

func _is_not_tile_floor(pos : Vector2i) -> bool:
	return not does_tile_contain_sprite(pos, TileTypes.FLOOR)
	
func _are_neighbors_floors(pos : Vector2i) -> bool:
	if get_neighbors(pos).any(_is_not_tile_floor):
		return false
	return true

func get_floor_groups(n_groups : int) -> Array:
	var groups = []
	for x in range(DungeonSize.MAX_X):
		for y in range(DungeonSize.MAX_Y):
			if _are_neighbors_floors(Vector2i(x, y)):
				groups.append(Vector2i(x, y))
	print(groups)
	return groups

func get_actor_at_pos(pos : Vector2i) -> Sprite2D:
	for type in TileTypes.actor_types:
		for sprite in _arr[pos.x + pos.y * DungeonSize.MAX_Y]:
			if sprite.get_groups().find(type) > -1:
				return sprite
	return null

func does_tile_contain_sprite(pos : Vector2i, sprite_type : String) -> bool:
	for sprite in _arr[pos.x + pos.y * DungeonSize.MAX_Y]:
		if sprite.get_groups().find(sprite_type) > -1:
			return true
	return false

func tile_type_fuzzy_search(pos : Vector2i, fuzzy_sprite : String) -> bool:
	for sprite in _arr[pos.x + pos.y * DungeonSize.MAX_Y]:
		for group in sprite.get_groups():
			if group.contains(fuzzy_sprite):
				return true
	return false

func move_sprite(old_pos : Vector2i, new_pos : Vector2i, sprite : Sprite2D):
	_arr[old_pos.x + old_pos.y * DungeonSize.MAX_Y].erase(sprite)
	set_sprite_at_pos(new_pos, sprite)

func remove_sprite_at_pos(pos : Vector2i, sprite : Sprite2D):
	_arr[pos.x + pos.y * DungeonSize.MAX_Y].erase(sprite)
	emit_signal("sprite_removed", pos, sprite)

func set_sprite_at_pos(pos : Vector2i, new_sprite: Sprite2D):
	#print("set_new_sprite", new_sprite)
	if _arr[pos.x + pos.y * DungeonSize.MAX_Y]:
		_arr[pos.x + pos.y * DungeonSize.MAX_Y].append(new_sprite)
	else:
		_arr[pos.x + pos.y * DungeonSize.MAX_Y] = [new_sprite]

func _on_InitWorld_sprite_created(new_sprite: Sprite2D):
	if new_sprite.get_groups().find(TileTypes.PC) > -1:
		_pc_ref = new_sprite 
	var pos = ConvertCoords.get_world_coords(new_sprite.position)
	set_sprite_at_pos(pos, new_sprite)
	if tile_type_fuzzy_search(pos, "wall"):
		_astargrid.set_point_solid(pos, true)
