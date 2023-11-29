extends Node2D

signal dwarf_attacks(message)

var _ref_DungeonGrid
var _ref_Schedule

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Schedule_turn_started_dwarf(current_sprite : Sprite2D) -> void:
	print(current_sprite, " is moving")
	var pc_pos = _ref_DungeonGrid.get_pc_pos()
	if _get_distance_from_pc(current_sprite) == 1:
		emit_signal("dwarf_attacks", "The dwarf attacks you!")
	var shortest = _ref_DungeonGrid.get_astar_path(ConvertCoords.get_world_coords(current_sprite.position), pc_pos)
	print(_ref_DungeonGrid.get_astar_path(ConvertCoords.get_world_coords(current_sprite.position), pc_pos))

	print(current_sprite, "     ", ConvertCoords.get_world_coords(current_sprite.position), "    ", pc_pos)
	if shortest.size() > 2:
			_ref_DungeonGrid.move_sprite(ConvertCoords.get_world_coords(current_sprite.position), shortest[1], current_sprite)
			current_sprite.position = ConvertCoords.get_local_coords(shortest[1])
			print("distance to pc: ", _get_distance_from_pc(current_sprite))
	#print(current_sprite, "     ", ConvertCoords.get_world_coords(current_sprite.position))
	_ref_Schedule.end_turn()

func _get_distance_from_pc(current_sprite : Sprite2D) -> int:
	var pc_pos : Vector2 = _ref_DungeonGrid.get_pc_pos()
	var current_pos = Vector2(ConvertCoords.get_world_coords(current_sprite.position))
	return pc_pos.distance_to(current_pos)
