extends Node2D

signal pc_attacked(message, dwarf)
signal pc_killed_dwarf(pos, dwarf)

var _ref_DungeonGrid
var _ref_Schedule

func attack(pos : Vector2i):
	var actor = _ref_DungeonGrid.get_actor_at_pos(pos)
	if actor:
		emit_signal("pc_attacked", "You swing at the dwarf!")
		emit_signal("pc_killed_dwarf", pos, actor)

