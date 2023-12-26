extends DungeonGridTemplate
class_name RewardGrid

const N_REWARDS : int = 2

func is_legal_move(pos : Vector2i) -> bool:
	if not is_inside_dungeon(pos):
		emit_signal("illegal_move", "You cannot leave the dungeon >:D")
		return false
	if tile_type_fuzzy_search(pos, "wall"):
		emit_signal("illegal_move", "You cannot move through walls...yet")
		return false
	if tile_type_fuzzy_search(pos, "holder"):
		emit_signal("illegal_move", "Something valuable might be here...")
		return false
	return true

func _init_dungeon():
	for x in range(_max_x):
		for y in range(_max_y):
			var pos = Vector2i(x, y)
			_create_sprite(TileTypes.FLOOR, pos)

#			var new_sprite: Sprite2D = AssetLoader.get_asset(TileTypes.FLOOR).instantiate() as Sprite2D
#			new_sprite.position = ConvertCoords.get_local_coords(pos)
#			new_sprite.add_to_group(TileTypes.FLOOR)
#			new_sprite.scale = Vector2(3, 3)
#			add_child(new_sprite)
#			emit_signal("sprite_created", new_sprite)
#			set_sprite_at_pos(pos, new_sprite)
	place_stairs_reward(Vector2i(0, 0))
	_init_player_reward(Vector2i(0, 0))
	_place_rewards()

func place_stairs_reward(pos : Vector2i):
	var stairs = AssetLoader.get_asset(TileTypes.DOWN_STAIRS).instantiate() as Sprite2D
	stairs.position = ConvertCoords.get_local_coords(pos)
	stairs.scale = Vector2(2, 2)
	stairs.add_to_group(TileTypes.DOWN_STAIRS)
	add_child(stairs)
	set_sprite_at_pos(pos, stairs)

func _place_rewards():
	for i in range(1, N_REWARDS + 1):
		var pos = Vector2i(i, (_max_y - 1))
		_create_sprite(TileTypes.ITEM_HOLDER, pos, Vector2(1.5, 1.5))
		var item = TileTypes.reward_items.pick_random()
		#var item = TileTypes.DRAGONS_LAMP
		_create_sprite(item, pos, Vector2(3, 3))
		_astargrid.set_point_solid(pos, true)

func _init_player_reward(pos : Vector2i):
	Globals.Player.set_grid_pos(pos)
	emit_signal("sprite_created", Globals.Player.get_pc())
	set_sprite_at_pos(pos, Globals.Player.get_pc())

#func _on_Player_item_picked_up(item : Sprite2D):
#	remove_item(item)
#
#func remove_item(item : Sprite2D):
#	var pos = ConvertCoords.get_world_coords(item.position)
#	_arr[pos].erase(item)
#	remove_child(item)
