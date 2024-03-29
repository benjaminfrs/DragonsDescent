extends DungeonGridTemplate
class_name DungeonGrid

signal dungeon_complete()
signal dwarf_placed(dwarf)
signal dungeon_initialized()

var _number_of_dwarves : int
var _difficulty : int

func _setup(number_of_dwarves : int = 0):
	_number_of_dwarves = number_of_dwarves
	_difficulty = number_of_dwarves
	#print("n dwarves: ", _number_of_dwarves)

func _on_Main_game_ready():
	pass

func _init_dungeon(map: Dictionary):
	for x in range(_max_x):
		for y in range(_max_y):
			var pos = Vector2i(x, y)
			_create_sprite(map[pos][0], pos)
	_init_actors()
	_place_dwarves(_number_of_dwarves)
	emit_signal("dungeon_initialized")

func is_legal_move_dwarf(pos : Vector2i) -> bool:
	if not is_inside_dungeon(pos):
		#emit_signal("illegal_move", "You cannot leave the dungeon >:D")
		return false
	if tile_type_fuzzy_search(pos, "wall"):
		#emit_signal("illegal_move", "You cannot move through walls...yet")
		return false
	if tile_type_fuzzy_search(pos, "dwarf"):
		#emit_signal("illegal_move", "There is a dwarf there!")
		return false
	if tile_type_fuzzy_search(pos, "pc"):
		#emit_signal("illegal_move", "Good thing that dwarf can't see you...")
		return false
	return true

func _init_actors():
	var floor_groups = get_floor_groups()
	var pc_pos = floor_groups.pop_front()
	
	Globals.Player.set_grid_pos(pc_pos)
	emit_signal("sprite_created", Globals.Player.get_pc())
	set_sprite_at_pos(pc_pos, Globals.Player.get_pc())

func _place_dwarves(n_dwarves : int):
	var floor_groups = get_floor_groups()
	while n_dwarves:
		var dwarf = _create_sprite(TileTypes.DWARF, floor_groups.pop_back(), Vector2(1, 1))
		emit_signal("dwarf_placed", dwarf)
		n_dwarves -= 1

func place_lamp():
	var lamp_pos = get_floor_groups().pick_random()
	_create_sprite(TileTypes.DRAGONS_LAMP, lamp_pos, Vector2(1.5, 1.5))

func place_stairs():
	var stair_pos = get_floor_groups().pick_random()
	var stairs = AssetLoader.get_asset(TileTypes.DOWN_STAIRS).instantiate() as Sprite2D
	stairs.position = ConvertCoords.get_local_coords(stair_pos)
	stairs.scale = Vector2(2, 2)
	stairs.add_to_group(TileTypes.DOWN_STAIRS)
	add_child(stairs)
	set_sprite_at_pos(stair_pos, stairs)



func _on_WandOfFireBolt_hit_dwarf(dwarf : Sprite2D):
	remove_sprite_at_pos(dwarf.get_grid_pos(), dwarf)
	_number_of_dwarves -= 1
	if not _number_of_dwarves:
		emit_signal("dungeon_complete")
		if _difficulty != 5:
			place_stairs()
		else:
			place_lamp()
	print("Dwarf killed!", dwarf)

func _on_PCAttack_pc_killed_dwarf(pos : Vector2i, dwarf : Sprite2D):
	remove_sprite_at_pos(pos, dwarf)
	_number_of_dwarves -= 1
	if not _number_of_dwarves:
		emit_signal("dungeon_complete")
		if _difficulty != 5:
			place_stairs()
		else:
			place_lamp()

func _on_Player_shot_projectile(bolt : Area2D, signals : Array):
	print("adding bolt to dungeon: ", bolt)
	add_child(bolt)
	for s in signals:
		s[1][s[0]].connect(self._on_WandOfFireBolt_hit_dwarf)

func _on_PCMove_down_stairs(pos : Vector2i):
	#print("moving down stairs")
	if does_tile_contain_sprite(pos, TileTypes.DOWN_STAIRS):
		emit_signal("leaving_dungeon")

