extends Node2D

signal illegal_move(message)

const InitWorld := preload("res://scene/main/World/InitWorld.gd")
var _ref_InitWorld: InitWorld

var _new_DungeonSize := preload("res://lib/DungeonSize.gd").new()
var _new_ConvertCoords := preload("res://lib/ConvertCoords.gd").new()
var _new_GroupName := preload("res://lib/GroupName.gd").new()

const Floor := preload("res://sprite/floor_sprite.tscn")

var _arr : Array

func _ready() -> void:
	_arr.resize(_new_DungeonSize.MAX_X * _new_DungeonSize.MAX_Y)
	_arr.fill(0)

func is_inside_dungeon(x: int, y: int) -> bool:
	return (x > -1) and (x < _new_DungeonSize.MAX_X) \
			and (y > -1) and (y < _new_DungeonSize.MAX_Y)

func is_legal_move(x: int, y: int) -> bool:
	if not is_inside_dungeon(x, y):
		emit_signal("illegal_move", "You cannot leave the dungeon >:D")
		return false
	if get_sprite_at_pos(x, y):
		if get_sprite_at_pos(x, y).is_in_group(_new_GroupName.WALL):
			emit_signal("illegal_move", "You cannot move through walls...yet")
			return false
	return true

func check_sprite_group_at_pos(x: int, y: int) -> String:
	if is_inside_dungeon(x, y):
		return get_sprite_at_pos(x, y).get_groups()[0]
	return ''

func get_sprite_at_pos(x: int, y: int) -> Sprite2D:
	if is_inside_dungeon(x, y):
		return _arr[x + y * _new_DungeonSize.MAX_Y]
	return null

func set_sprite_at_pos(x:int, y: int, new_sprite: Sprite2D):
	_arr[x + y * _new_DungeonSize.MAX_Y] = new_sprite
	

func _on_InitWorld_sprite_created(new_sprite: Sprite2D):
	var pos := _new_ConvertCoords.vector_to_array(new_sprite.position)
	print(pos, new_sprite.get_groups())
	set_sprite_at_pos(pos[0], pos[1], new_sprite)

func _on_RemoveObject_sprite_removed(sprite: Sprite2D, x: int, y: int):
	#set_sprite_at_pos(x, y, 0)
	_ref_InitWorld._create_sprite(Floor, _new_GroupName.FLOOR, x, y)
