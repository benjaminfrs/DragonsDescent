extends Node2D

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
	var shortest = _ref_DungeonGrid.get_astar_path(ConvertCoords.get_world_coords(current_sprite.position), pc_pos)
	print(_ref_DungeonGrid.get_astar_path(ConvertCoords.get_world_coords(current_sprite.position), pc_pos))
	_ref_DungeonGrid.move_sprite(ConvertCoords.get_world_coords(current_sprite.position), shortest[0], current_sprite)
	print(current_sprite, "     ", ConvertCoords.get_world_coords(current_sprite.position))
	if shortest.size() > 2:
		current_sprite.position = ConvertCoords.get_local_coords(shortest[1])
	print(current_sprite, "     ", ConvertCoords.get_world_coords(current_sprite.position))
	_ref_Schedule.end_turn()
