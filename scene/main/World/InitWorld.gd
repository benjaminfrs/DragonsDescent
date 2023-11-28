extends Node2D

signal sprite_created(new_sprite)

var _ref_DungeonGrid

const Player := preload("res://sprite/pc.tscn")
const Dwarf := preload("res://sprite/d_sprite.tscn")
const Floor := preload("res://sprite/floor_sprite.tscn")
const xArrow := preload("res://sprite/x_sprite.tscn")
const yArrow := preload("res://sprite/y_sprite.tscn")
const Wall := preload("res://sprite/wall_sprite.tscn")
const Ulwall := preload("res://sprite/ulwall_sprite.tscn")
const Urwall := preload("res://sprite/urwall_sprite.tscn")
const Brwall := preload("res://sprite/brwall_sprite.tscn")
const Blwall := preload("res://sprite/blwall_sprite.tscn")
const Bewall := preload ("res://sprite/bewall_sprite.tscn")
const Uewall := preload ("res://sprite/uewall_sprite.tscn")
const Rewall := preload ("res://sprite/rewall_sprite.tscn")
const Lewall := preload ("res://sprite/lewall_sprite.tscn")
const Failed := preload("res://sprite/failed_sprite.tscn")

func _on_MapGenerator_map_finished(map: Array):
	var pc_placed = false
	#print(map)
	for i in range(DungeonSize.MAX_X):
		for j in range(DungeonSize.MAX_Y):
			var new_sprite: Sprite2D = _get_asset(map[i + j * DungeonSize.MAX_Y]).instantiate() as Sprite2D
			new_sprite.position = ConvertCoords.get_local_coords(Vector2i(i, j), 0, 0)
			new_sprite.add_to_group(map[i + j * DungeonSize.MAX_Y])
			new_sprite.scale = Vector2(3, 3)
			add_child(new_sprite)
			emit_signal("sprite_created", new_sprite)
	_init_actors(3)

func _init_actors(n_dwarves : int):
	var floor_groups = _ref_DungeonGrid.get_floor_groups(0)
	print(floor_groups)
	var pc_pos = floor_groups.pop_front()
	
	var pc = Player.instantiate() as Sprite2D
	pc.position = ConvertCoords.get_local_coords(pc_pos)
	pc.scale = Vector2(2, 2)
	pc.add_to_group(TileTypes.PC)
	add_child(pc)
	emit_signal("sprite_created", pc)
	
	for _ind in range(n_dwarves):
		var new_dwarf = Dwarf.instantiate() as Sprite2D
		var new_pos = floor_groups.pop_back()
		
		new_dwarf.position = ConvertCoords.get_local_coords(new_pos)
		new_dwarf.scale = Vector2(2, 2)
		new_dwarf.add_to_group(TileTypes.DWARF)
		add_child(new_dwarf)
		emit_signal("sprite_created", new_dwarf)


func _get_asset(groupName: String) -> PackedScene:
	if groupName == "blwall":
		return Blwall
	if groupName == "failed":
		return Failed
	if groupName == "lewall":
		return Lewall
	if groupName == "rewall":
		return Rewall
	if groupName == "uewall":
		return Uewall
	if groupName == "brwall":
		return Brwall
	if groupName == "bewall":
		return Bewall
	if groupName == "ulwall":
		return Ulwall
	if groupName == "urwall":
		return Urwall
	if groupName == ("wall"):
		return Wall
	if groupName == "dwarf":
		return Dwarf
	if groupName == "floor":
		return Floor
	return null

func _create_sprite(prefab: PackedScene, group: String, pos : Vector2i,
		x_offset: int = 0, y_offset: int = 0, sprite_scale = 0) -> void:

	var new_sprite: Sprite2D = prefab.instantiate() as Sprite2D
	new_sprite.position = ConvertCoords.get_local_coords(pos, x_offset, y_offset)
	if sprite_scale:
		new_sprite.scale = Vector2(sprite_scale, sprite_scale)
	new_sprite.add_to_group(group)

	add_child(new_sprite)
	emit_signal("sprite_created", new_sprite)
