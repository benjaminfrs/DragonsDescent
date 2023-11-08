extends Node2D

var _ref_Schedule

var _new_GroupName


func _on_Schedule_turn_started(current_sprite: Sprite2D) -> void:
	if not current_sprite.is_in_group(_new_GroupName.DWARF):
		return

	_ref_Schedule.end_turn()
