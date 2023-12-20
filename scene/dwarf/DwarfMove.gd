extends Node

signal dwarf_attacks(message)

var _ref_DungeonGrid
var _ref_Schedule
var _dwarf
var _properties = {}

func setup(ref_DungeonGrid, ref_Schedule, dwarf):
	_ref_DungeonGrid = ref_DungeonGrid
	_ref_Schedule = ref_Schedule
	print(ref_Schedule)
	_dwarf = dwarf

func _on_Schedule_turn_started_dwarf(current_sprite : Sprite2D) -> void:
	pass

func take_turn():
	var pc_pos = Globals.Player.get_grid_pos()
	if Globals.Player.get_property("invisible"):
		while not _try_random_step():
			pass
		_ref_Schedule.end_turn()
		return
	if _get_distance_from_pc(_dwarf) == 1:
		if not _dwarf.get_property("in_smoke"):
			emit_signal("dwarf_attacks", "The dwarf attacks you!")
		else:
			print("The dwarf is blinded!")
		_ref_Schedule.end_turn()
		return
	var shortest = _ref_DungeonGrid.get_astar_path(ConvertCoords.get_world_coords(_dwarf.position), pc_pos)
	if shortest.size() > 2:
			_ref_DungeonGrid.move_sprite(_dwarf.get_grid_pos(), shortest[1], _dwarf)
			_dwarf.set_grid_pos(shortest[1])
	_ref_Schedule.end_turn()

func _get_distance_from_pc(current_sprite : Sprite2D) -> int:
	var pc_pos : Vector2 = Globals.Player.get_grid_pos()
	var current_pos = Vector2(ConvertCoords.get_world_coords(current_sprite.position))
	return pc_pos.distance_to(current_pos)

func _try_random_step():
	var new_pos = TileRules.get_neighbors(_dwarf.get_grid_pos()).pick_random()
	if _ref_DungeonGrid.is_legal_move_dwarf(new_pos):
		_ref_DungeonGrid.move_sprite(_dwarf.get_grid_pos(), new_pos, _dwarf)
		_dwarf.set_grid_pos(new_pos)
		return true
	return false

func set_property(key, val):
	self._properties[key] = val

func get_property(key):
	return self._properties[key]
