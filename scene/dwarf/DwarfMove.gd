extends Node

signal dwarf_attacks(message)

var _ref_DungeonGrid
var _ref_Schedule
var _dwarf

func setup(ref_DungeonGrid, ref_Schedule, dwarf):
	_ref_DungeonGrid = ref_DungeonGrid
	_ref_Schedule = ref_Schedule
	print(ref_Schedule)
	_dwarf = dwarf

func _on_Schedule_turn_started_dwarf(current_sprite : Sprite2D) -> void:
	pass

func take_turn():
	var pc_pos = Globals.Player.get_grid_pos()
	if _get_distance_from_pc(_dwarf) == 1:
		emit_signal("dwarf_attacks", "The dwarf attacks you!")
	var shortest = _ref_DungeonGrid.get_astar_path(ConvertCoords.get_world_coords(_dwarf.position), pc_pos)
	if shortest.size() > 2:
			_ref_DungeonGrid.move_sprite(_dwarf.get_grid_pos(), shortest[1], _dwarf)
			_dwarf.set_grid_pos(shortest[1])
	_ref_Schedule.end_turn()

func _get_distance_from_pc(current_sprite : Sprite2D) -> int:
	var pc_pos : Vector2 = Globals.Player.get_grid_pos()
	var current_pos = Vector2(ConvertCoords.get_world_coords(current_sprite.position))
	return pc_pos.distance_to(current_pos)
