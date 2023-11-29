extends Node2D

signal illegal_move(message)
signal sprite_removed(pos, sprite)
signal sprite_created(sprite)

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

func _is_not_tile_floor(pos : Vector2i) -> bool:
	return not does_tile_contain_sprite(pos, TileTypes.FLOOR)
	
func _are_neighbors_floors(pos : Vector2i) -> bool:
	if TileRules.get_neighbors(pos).any(_is_not_tile_floor):
		return false
	return true

func get_floor_groups(n_groups : int) -> Array:
	var groups = []
	for x in range(DungeonSize.MAX_X):
		for y in range(DungeonSize.MAX_Y):
			if _are_neighbors_floors(Vector2i(x, y)):
				groups.append(Vector2i(x, y))
	return groups

func get_actor_at_pos(pos : Vector2i) -> Sprite2D:
	for type in TileTypes.actor_types:
		for sprite in _arr[pos.x + pos.y * DungeonSize.MAX_Y]:
			if sprite.get_groups().find(type) > -1:
				return sprite
	return null

func does_tile_contain_sprite(pos : Vector2i, sprite_type : String) -> bool:
	for sprite in _arr[pos.x + pos.y * DungeonSize.MAX_Y]:
		if is_sprite_in_group(sprite, sprite_type):
			return true
	return false

func is_sprite_in_group(sprite : Sprite2D, group : String) -> bool:
	if sprite.get_groups().find(group) > -1:
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
	if is_sprite_in_group(sprite, TileTypes.DWARF):
		_astargrid.set_point_solid(old_pos, false)
		_astargrid.set_point_solid(new_pos, true)

func remove_sprite_at_pos(pos : Vector2i, sprite : Sprite2D):
	#print(_arr[pos.x + pos.y * DungeonSize.MAX_Y])
	_arr[pos.x + pos.y * DungeonSize.MAX_Y].erase(sprite)
	#print(_arr[pos.x + pos.y * DungeonSize.MAX_Y])
	emit_signal("sprite_removed", pos, sprite)

func set_sprite_at_pos(pos : Vector2i, new_sprite: Sprite2D):
	#print("set_new_sprite", new_sprite)
	if _arr[pos.x + pos.y * DungeonSize.MAX_Y]:
		_arr[pos.x + pos.y * DungeonSize.MAX_Y].append(new_sprite)
	else:
		_arr[pos.x + pos.y * DungeonSize.MAX_Y] = [new_sprite]

func _on_MapGenerator_map_finished(map: Array):
	for x in range(DungeonSize.MAX_X):
		for y in range(DungeonSize.MAX_Y):
			var pos = Vector2i(x, y)
			var new_sprite: Sprite2D = AssetLoader.get_asset(map[pos.x + pos.y * DungeonSize.MAX_Y]).instantiate() as Sprite2D
			new_sprite.position = ConvertCoords.get_local_coords(pos, 0, 0)
			new_sprite.add_to_group(map[pos.x + pos.y * DungeonSize.MAX_Y])
			new_sprite.scale = Vector2(3, 3)
			add_child(new_sprite)
			emit_signal("sprite_created", new_sprite)
			set_sprite_at_pos(pos, new_sprite)
			if tile_type_fuzzy_search(pos, "wall"):
				_astargrid.set_point_solid(pos, true)
	_init_actors(3)

func _init_actors(n_dwarves : int):
	var floor_groups = get_floor_groups(0)
	#print(floor_groups)
	var pc_pos = floor_groups.pop_front()
	
	var pc = AssetLoader.Player.instantiate() as Sprite2D
	_pc_ref = pc
	pc.position = ConvertCoords.get_local_coords(pc_pos)
	pc.scale = Vector2(2, 2)
	pc.add_to_group(TileTypes.PC)
	add_child(pc)
	emit_signal("sprite_created", pc)
	set_sprite_at_pos(pc_pos, pc)
	
	for _ind in range(n_dwarves):
		var new_dwarf = AssetLoader.Dwarf.instantiate() as Sprite2D
		var new_pos = floor_groups.pop_back()
		
		new_dwarf.position = ConvertCoords.get_local_coords(new_pos)
		new_dwarf.scale = Vector2(2, 2)
		new_dwarf.add_to_group(TileTypes.DWARF)
		add_child(new_dwarf)
		emit_signal("sprite_created", new_dwarf)
		set_sprite_at_pos(new_pos, new_dwarf)

#func _on_InitWorld_sprite_created(new_sprite: Sprite2D):
#	if new_sprite.get_groups().find(TileTypes.PC) > -1:
#		_pc_ref = new_sprite 
#	var pos = ConvertCoords.get_world_coords(new_sprite.position)
#	set_sprite_at_pos(pos, new_sprite)
#	if tile_type_fuzzy_search(pos, "wall"):
#		_astargrid.set_point_solid(pos, true)
