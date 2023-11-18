extends Node2D

var _ref_Schedule

func _on_Schedule_turn_started(current_sprite: Sprite2D) -> void:
	if not current_sprite.is_in_group(TileTypes.DWARF):
		return

	_ref_Schedule.end_turn()
