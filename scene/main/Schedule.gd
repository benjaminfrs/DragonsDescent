extends Node2D

signal turn_started(current_sprite)

var _pointer: int = 0

var _new_GroupName := preload("res://lib/GroupName.gd").new()
var _actors: Array = [null]

func end_turn() -> void:
	print("{0}: End turn.".format([_get_current().name]))
	_goto_next()
	emit_signal("turn_started", _get_current())


func _get_current() -> Sprite2D:
	return _actors[_pointer] as Sprite2D


func _goto_next() -> void:
	_pointer += 1

	if _pointer > len(_actors) - 1:
		_pointer = 0

func _on_InitWorld_sprite_created(new_sprite: Sprite2D) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_actors[0] = new_sprite
	elif new_sprite.is_in_group(_new_GroupName.DWARF):
		print("here")
		_actors.append(new_sprite)
