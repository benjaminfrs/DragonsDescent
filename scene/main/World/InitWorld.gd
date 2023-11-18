extends Node2D

signal sprite_created(new_sprite)

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

func _unhandled_input(event: InputEvent) -> void:
	pass
	#if event.is_action_pressed(InputNames.INIT_WORLD):
	#	_init_floor()
	#	_init_wall()
	#	_init_PC()
	#	_init_dwarf()
	#	_init_indicator()

	#	set_process_unhandled_input(false)

func _ready() -> void:
	pass

func _on_MapGenerator_tile_placed(groupName: String, x: int, y: int, x_offset: int = 0, y_offset: int = 0):
	var new_sprite: Sprite2D = _get_asset(groupName).instantiate() as Sprite2D
	new_sprite.position = ConvertCoords.index_to_vector(x, y, x_offset, y_offset)
	if groupName.contains("wall"):
		new_sprite.add_to_group("wall")
	else:
		new_sprite.add_to_group(groupName)

	add_child(new_sprite)
	emit_signal("sprite_created", new_sprite)

func _on_MapGenerator_map_finished(map: Array):
	var pc_placed = false
	for i in range(DungeonSize.MAX_X):
		for j in range(DungeonSize.MAX_Y):
			var new_sprite: Sprite2D = _get_asset(map[i + j * DungeonSize.MAX_Y]).instantiate() as Sprite2D
			new_sprite.position = ConvertCoords.index_to_vector(i, j, 0, 0)
			new_sprite.add_to_group(map[i + j * DungeonSize.MAX_Y])
			add_child(new_sprite)
			emit_signal("sprite_created", new_sprite)
			if not pc_placed and map[i + j * DungeonSize.MAX_Y] == TileTypes.FLOOR:
				var pc : Sprite2D = Player.instantiate() as Sprite2D
				pc.position = ConvertCoords.index_to_vector(i, j, 0, 0)
				pc.add_to_group(TileTypes.PC)
				pc_placed = true
				add_child(pc)
				emit_signal("sprite_created", pc)


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
	if groupName.contains("wall"):
		return Wall
	if groupName == "dwarf":
		return Dwarf
	if groupName == "floor":
		return Floor
	return null

func _init_dwarf() -> void:
	_create_sprite(Dwarf, TileTypes.DWARF, 3, 3)
	_create_sprite(Dwarf, TileTypes.DWARF, 14, 5)
	_create_sprite(Dwarf, TileTypes.DWARF, 7, 11)


func _init_PC() -> void:
	_create_sprite(Player, TileTypes.PC, 0, 0)

func _init_wall() -> void:
	var shift: int = 2
	var min_x: int = DungeonSize.CENTER_X - shift
	var max_x: int = DungeonSize.CENTER_X + shift + 1
	var min_y: int = DungeonSize.CENTER_Y - shift
	var max_y: int = DungeonSize.CENTER_Y + shift + 1

	for i in range(min_x, max_x):
		for j in range(min_y, max_y):
			_create_sprite(Wall, TileTypes.WALL, i, j)


func _init_floor() -> void:
	for i in range(DungeonSize.MAX_X):
		for j in range(DungeonSize.MAX_Y):
			_create_sprite(Floor, TileTypes.FLOOR, i, j)


func _init_indicator() -> void:
	_create_sprite(xArrow, TileTypes.ARROW, 0, 12,
			-DungeonSize.ARROW_MARGIN, 0)
	_create_sprite(yArrow, TileTypes.ARROW, 5, 0,
			0, -DungeonSize.ARROW_MARGIN)


func _create_sprite(prefab: PackedScene, group: String, x: int, y: int,
		x_offset: int = 0, y_offset: int = 0) -> void:

	var new_sprite: Sprite2D = prefab.instantiate() as Sprite2D
	new_sprite.position = ConvertCoords.index_to_vector(x, y, x_offset, y_offset)
	new_sprite.add_to_group(group)

	add_child(new_sprite)
	emit_signal("sprite_created", new_sprite)
	#if new_sprite.is_in_group(TileTypes.PC):
		#print(new_sprite.get_groups())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
