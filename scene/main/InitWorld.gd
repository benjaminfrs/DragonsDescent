extends Node2D

signal sprite_created(new_sprite)

const Player := preload("res://sprite/pc.tscn")
const Dwarf := preload("res://sprite/d_sprite.tscn")
const Floor := preload("res://sprite/floor_sprite.tscn")
const xArrow := preload("res://sprite/x_sprite.tscn")
const yArrow := preload("res://sprite/y_sprite.tscn")
const Wall := preload("res://sprite/wall_sprite.tscn")

var _new_GroupName := preload("res://lib/GroupName.gd").new()
var _new_ConvertCoords := preload("res://lib/ConvertCoords.gd").new()
var _new_DungeonSize := preload("res://lib/DungeonSize.gd").new()
var _new_InputName := preload("res://lib/InputName.gd").new()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(_new_InputName.INIT_WORLD):
		_init_floor()
		_init_wall()
		_init_PC()
		_init_dwarf()
		_init_indicator()

		set_process_unhandled_input(false)

func _ready() -> void:
	pass


func _init_dwarf() -> void:
	_create_sprite(Dwarf, _new_GroupName.DWARF, 3, 3)
	_create_sprite(Dwarf, _new_GroupName.DWARF, 14, 5)
	_create_sprite(Dwarf, _new_GroupName.DWARF, 7, 11)


func _init_PC() -> void:
	_create_sprite(Player, _new_GroupName.PC, 0, 0)

func _init_wall() -> void:
	var shift: int = 2
	var min_x: int = _new_DungeonSize.CENTER_X - shift
	var max_x: int = _new_DungeonSize.CENTER_X + shift + 1
	var min_y: int = _new_DungeonSize.CENTER_Y - shift
	var max_y: int = _new_DungeonSize.CENTER_Y + shift + 1

	for i in range(min_x, max_x):
		for j in range(min_y, max_y):
			_create_sprite(Wall, _new_GroupName.WALL, i, j)


func _init_floor() -> void:
	for i in range(_new_DungeonSize.MAX_X):
		for j in range(_new_DungeonSize.MAX_Y):
			_create_sprite(Floor, _new_GroupName.FLOOR, i, j)


func _init_indicator() -> void:
	_create_sprite(xArrow, _new_GroupName.ARROW, 0, 12,
			-_new_DungeonSize.ARROW_MARGIN, 0)
	_create_sprite(yArrow, _new_GroupName.ARROW, 5, 0,
			0, -_new_DungeonSize.ARROW_MARGIN)


func _create_sprite(prefab: PackedScene, group: String, x: int, y: int,
		x_offset: int = 0, y_offset: int = 0) -> void:

	var new_sprite: Sprite2D = prefab.instantiate() as Sprite2D
	new_sprite.position = _new_ConvertCoords.index_to_vector(
			x, y, x_offset, y_offset)
	new_sprite.add_to_group(group)

	add_child(new_sprite)
	emit_signal("sprite_created", new_sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
