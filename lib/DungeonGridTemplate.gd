extends Node2D
class_name DungeonGridTemplate

signal illegal_move(message)
signal sprite_removed(pos, sprite)
signal sprite_created(sprite)
#signal dungeon_complete()
signal leaving_dungeon()

var _arr : Dictionary
var _astargrid : AStarGrid2D

var _max_x : int
var _max_y : int

func set_dungeon_size(max_x : int, max_y : int):
	_max_x = max_x
	_max_y = max_y
	print(self, _max_x, _max_y)
	
	_astargrid = AStarGrid2D.new()
	_astargrid.size = Vector2i(_max_x, _max_y)
	_astargrid.cell_size = Vector2i(ConvertCoords.STEP_X, ConvertCoords.STEP_Y)
	_astargrid.update()
	_init_out_of_bounds_area()

func _init_out_of_bounds_area():
	var height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var screen_width_mid = ProjectSettings.get_setting("display/window/size/viewport_width") / 2.0
	var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var grid_width = ConvertCoords.STEP_X * _max_x
	var grid_height = ConvertCoords.STEP_Y * _max_y
	var bottom_box_height_midpoint = height - ((height - ConvertCoords.START_Y - grid_height) / 2.0)
	var right_box_width_midpoint = screen_width - ((screen_width - ConvertCoords.START_X - grid_width) / 2.0)
	print("window size(width x height): ", screen_width, " x ", height, "  grid width x height", grid_width, " x ", grid_height)

# Top OOB Box
	var collision_shape_top = CollisionShape2D.new()
	var OOB_rec1 = RectangleShape2D.new()
	OOB_rec1.size = Vector2(screen_width, ConvertCoords.START_Y)
	collision_shape_top.set_shape(OOB_rec1)
	collision_shape_top.set_debug_color(Color(0.0, 1.0, 0.0, 0.3))

	var OOB_area1 = Area2D.new()
	OOB_area1.position = Vector2(screen_width_mid, (ConvertCoords.START_Y)/2 - ConvertCoords.STEP_Y/2)
	OOB_area1.add_child(collision_shape_top)
	OOB_area1.add_to_group("OutOfBounds1")

# Bottom OOB Box	
	var collision_shape_bottom = CollisionShape2D.new()
	var OOB_rec2 = RectangleShape2D.new()
	OOB_rec2.size = Vector2(screen_width, (height - ConvertCoords.START_Y - grid_height))
	collision_shape_bottom.set_shape(OOB_rec2)
	collision_shape_bottom.set_debug_color(Color(0.0, 1.0, 0.0, 0.3))

	var OOB_area2 = Area2D.new()
	OOB_area2.position = Vector2(screen_width_mid, bottom_box_height_midpoint - ConvertCoords.STEP_Y / 2)
	OOB_area2.add_child(collision_shape_bottom)
	OOB_area2.add_to_group("OutOfBounds2")

# Left Side OOB Box
	var collision_shape_left = CollisionShape2D.new()
	var OOB_rec3 = RectangleShape2D.new()
	OOB_rec3.size = Vector2(ConvertCoords.START_X, height)
	collision_shape_left.set_shape(OOB_rec3)
	collision_shape_left.set_debug_color(Color(0.0, 1.0, 0.0, 0.3))

	var OOB_area3 = Area2D.new()
	OOB_area3.position = Vector2(ConvertCoords.START_X / 2 - ConvertCoords.STEP_X / 2, height / 2)
	OOB_area3.add_child(collision_shape_left)
	OOB_area3.add_to_group("OutOfBounds3")

# Right Side OOB Box
	var collision_shape_right = CollisionShape2D.new()
	var OOB_rec4 = RectangleShape2D.new()
	OOB_rec4.size = Vector2((screen_width - ConvertCoords.START_X - grid_width), height)
	collision_shape_right.set_shape(OOB_rec4)
	collision_shape_right.set_debug_color(Color(0.0, 1.0, 0.0, 0.3))

	var OOB_area4 = Area2D.new()
	OOB_area4.position = Vector2(right_box_width_midpoint - ConvertCoords.STEP_X / 2, height / 2)
	OOB_area4.add_child(collision_shape_right)
	OOB_area4.add_to_group("OutOfBounds3")
	
	self.add_child(OOB_area1)
	self.add_child(OOB_area2)
	self.add_child(OOB_area3)
	self.add_child(OOB_area4)
	print(self.get_children())

func is_inside_dungeon(pos : Vector2i) -> bool:
	if pos.x < 0 or pos.x >= _max_x:
		return false
	if pos.y < 0 or pos.y >= _max_y:
		return false
	return true


func _ready():
	print(self, "READYYYYYYYY")

func get_astar_path(a : Vector2i, b : Vector2i) -> Array:
	return _astargrid.get_id_path(a, b)

func is_legal_move(pos : Vector2i) -> bool:
	if not is_inside_dungeon(pos):
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
	for x in range(_max_x):
		for y in range(_max_y):
			if _are_neighbors_floors(Vector2i(x, y)):
				groups.append(Vector2i(x, y))
	return groups

func get_actor_at_pos(pos : Vector2i) -> Sprite2D:
	for type in TileTypes.actor_types:
		for sprite in _arr[pos]:
			if sprite.get_groups().find(type) > -1:
				return sprite
	return null

func get_item_at_pos(pos : Vector2i) -> Sprite2D:
	for item in TileTypes.reward_items:
		for sprite in _arr[pos]:
			if sprite.get_groups().find(item) > -1:
				return sprite
	return null

func does_tile_contain_sprite(pos : Vector2i, sprite_type : String) -> bool:
	for sprite in _arr[pos]:
		if is_sprite_in_group(sprite, sprite_type):
			return true
	return false

func is_sprite_in_group(sprite : Sprite2D, group : String) -> bool:
	if sprite.get_groups().find(group) > -1:
		return true
	return false

func tile_type_fuzzy_search(pos : Vector2i, fuzzy_sprite : String) -> bool:
	for sprite in _arr[pos]:
		for group in sprite.get_groups():
			if group.contains(fuzzy_sprite):
				return true
	return false

func move_sprite(old_pos : Vector2i, new_pos : Vector2i, sprite : Sprite2D):
	_arr[old_pos].erase(sprite)
	set_sprite_at_pos(new_pos, sprite)
	if is_sprite_in_group(sprite, TileTypes.DWARF):
		_astargrid.set_point_solid(old_pos, false)
		_astargrid.set_point_solid(new_pos, true)

func remove_sprite_at_pos(pos : Vector2i, sprite : Sprite2D):
	#print(_arr[pos.x + pos.y * _max_y])
	_arr[pos].erase(sprite)
	for group in sprite.get_groups():
		if TileTypes.actor_types.find(group) > -1:
			_astargrid.set_point_solid(pos, false)
	#print(_arr[pos.x + pos.y * _max_y])
	emit_signal("sprite_removed", pos, sprite)

func set_sprite_at_pos(pos : Vector2i, new_sprite):
	#print("set_new_sprite", new_sprite)
	if _arr.has(pos):
		_arr[pos].append(new_sprite)
	else:
		_arr[pos] = [new_sprite]

func _init_player():
	var floor_groups = get_floor_groups(0)
	var pc_pos = floor_groups.pop_front()
	
	Globals.Player.set_grid_pos(pc_pos)
	emit_signal("sprite_created", Globals.Player.get_pc())
	set_sprite_at_pos(pc_pos, Globals.Player.get_pc())


func place_stairs():
	var stair_pos = get_floor_groups(0).pick_random()
	var stairs = AssetLoader.DownStairs.instantiate() as Sprite2D
	stairs.position = ConvertCoords.get_local_coords(stair_pos)
	stairs.scale = Vector2(2, 2)
	stairs.add_to_group(TileTypes.DOWN_STAIRS)
	add_child(stairs)
	set_sprite_at_pos(stair_pos, stairs)


func _on_Player_down_stairs(pos : Vector2i):
	#print("moving down stairs")
	if does_tile_contain_sprite(pos, TileTypes.DOWN_STAIRS):
		emit_signal("leaving_dungeon")

func _on_Player_shot_projectile(bolt : Area2D, signals : Array):
	print("adding bolt to dungeon: ", bolt)
	add_child(bolt)
	for s in signals:
		s[1][s[0]].connect(self._on_WandOfFireBolt_hit_dwarf)

func _on_WandOfFireBolt_hit_dwarf(dwarf : Sprite2D):
	remove_sprite_at_pos(dwarf.get_grid_pos(), dwarf)
	print("Dwarf killed!", dwarf)

func _create_sprite(sprite_type : String, pos : Vector2i, s_scale : Vector2 = Vector2(3,3)):
	#print("creating sprite: ", pos, ConvertCoords.get_local_coords(pos))
	var new_sprite = AssetLoader.get_asset(sprite_type).instantiate()
	new_sprite.add_to_group(sprite_type)
	new_sprite.scale = s_scale
	new_sprite.position = ConvertCoords.get_local_coords(pos)
	print(new_sprite, new_sprite.position, s_scale)
	add_child(new_sprite)
	emit_signal("sprite_created", new_sprite)
	set_sprite_at_pos(pos, new_sprite)
	if tile_type_fuzzy_search(pos, "wall"):
		_astargrid.set_point_solid(pos, true)
	return new_sprite
