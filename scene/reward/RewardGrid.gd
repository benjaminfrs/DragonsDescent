extends DungeonGridTemplate
class_name RewardGrid

func _init_dungeon():
	for x in range(_max_x):
		for y in range(_max_y):
			var pos = Vector2i(x, y)
			var new_sprite: Sprite2D = AssetLoader.get_asset(TileTypes.FLOOR).instantiate() as Sprite2D
			new_sprite.position = ConvertCoords.get_local_coords(pos)
			new_sprite.add_to_group(TileTypes.FLOOR)
			new_sprite.scale = Vector2(3, 3)
			add_child(new_sprite)
			emit_signal("sprite_created", new_sprite)
			set_sprite_at_pos(pos, new_sprite)
	place_stairs_reward(Vector2i(0, 0))
	_init_player_reward(Vector2i(0, 0))

func place_stairs_reward(pos : Vector2i):
	var stairs = AssetLoader.DownStairs.instantiate() as Sprite2D
	stairs.position = ConvertCoords.get_local_coords(pos)
	stairs.scale = Vector2(2, 2)
	stairs.add_to_group(TileTypes.DOWN_STAIRS)
	add_child(stairs)
	set_sprite_at_pos(pos, stairs)

func _init_player_reward(pos : Vector2i):
	Globals.Player.set_grid_pos(pos)
	emit_signal("sprite_created", Globals.Player.get_pc())
	set_sprite_at_pos(pos, Globals.Player.get_pc())

