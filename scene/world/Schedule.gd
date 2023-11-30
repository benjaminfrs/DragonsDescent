extends Node2D

signal turn_started_pc(current_sprite)
signal turn_started_dwarf(current_sprite)
signal turn_started(current_sprite)
signal turn_ended(current_sprite)

var _pointer: int = 0

var _actors: Array = [null]

func end_turn() -> void:
	#print("{0}: End turn.".format([_get_current().name]))
	emit_signal("turn_ended", _get_current())
	_goto_next()
	var turn_signal = "turn_started_" + _get_current().get_groups()[0]
	#print(turn_signal)
	emit_signal(turn_signal, _get_current())
	emit_signal("turn_started", _get_current())


func _get_current() -> Sprite2D:
	return _actors[_pointer] as Sprite2D


func _goto_next() -> void:
	_pointer += 1

	if _pointer > len(_actors) - 1:
		_pointer = 0

func _on_DungeonGrid_sprite_created(new_sprite: Sprite2D) -> void:
	if new_sprite.is_in_group(TileTypes.PC):
		_actors[0] = new_sprite
	elif new_sprite.is_in_group(TileTypes.DWARF):
		_actors.append(new_sprite)
	#print(_actors)

func _on_DungeonGrid_sprite_removed(pos : Vector2i, sprite : Sprite2D):
	_actors.erase(sprite)
	sprite.queue_free()
	_pointer = _actors.find(_get_current())
