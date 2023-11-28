extends Node2D

signal pc_attacked(message)

var _ref_DungeonGrid
var _ref_Schedule

func attack(pos : Vector2i):

	var actor = _ref_DungeonGrid.get_actor_at_pos(pos)
	if actor:
		_ref_DungeonGrid.remove_sprite_at_pos(pos, actor)
		emit_signal("pc_attacked", "You swing at the dwarf!")
	#_ref_RemoveObject.remove(pos)
