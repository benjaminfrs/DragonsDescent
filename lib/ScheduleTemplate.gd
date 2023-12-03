extends Node
class_name ScheduleTemplate

#signal turn_started_pc(current_sprite)
#signal turn_started_dwarf(current_sprite)
#signal turn_started(current_sprite)
#signal turn_ended(current_sprite)

var _pointer: int = 0
var _actors: Array = []

func end_turn() -> void:
	_goto_next()
	_get_current().take_turn()


func _get_current() -> Sprite2D:
	return _actors[_pointer] as Sprite2D


func _goto_next() -> void:
	_pointer += 1

	if _pointer > len(_actors) - 1:
		_pointer = 0

func _on_DungeonGrid_sprite_created(new_sprite: Sprite2D) -> void:
	if TileTypes.is_sprite_actor(new_sprite):
		_actors.append(new_sprite)

func _on_DungeonGrid_sprite_removed(pos : Vector2i, sprite : Sprite2D):
	_actors.erase(sprite)
	sprite.queue_free()
	_pointer = _actors.find(_get_current())

func _on_PCMove_pc_ended_turn():
	end_turn()
