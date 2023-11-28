extends Node2D

var _ref_Schedule
var _ref_DungeonGrid

var _pc: Sprite2D
var _move_inputs: Array

func _ready() -> void:
	set_process_unhandled_input(false)

func _on_Main_game_ready():
	_move_inputs = [
		InputNames.MOVE_LEFT,
		InputNames.MOVE_RIGHT,
		InputNames.MOVE_UP,
		InputNames.MOVE_DOWN,
	]

func _unhandled_input(event: InputEvent) -> void:
	var source: Vector2i = ConvertCoords.get_world_coords(_pc.position)
	if _is_move_input(event):
		_try_move(_get_new_position(event, source), source)

func _on_InitWorld_sprite_created(new_sprite: Sprite2D) -> void:
	if new_sprite.is_in_group(TileTypes.PC):
		_pc = new_sprite
		set_process_unhandled_input(true)


func _on_Schedule_turn_started_pc(current_sprite: Sprite2D) -> void:
	if current_sprite.is_in_group(TileTypes.PC):
		set_process_unhandled_input(true)

func _is_move_input(event: InputEvent) -> bool:
	for m in _move_inputs:
		if event.is_action_pressed(m):
			return true
	return false


func _get_new_position(event: InputEvent, source: Vector2i) -> Vector2i:
	var temp = Vector2i(source.x, source.y)

	if event.is_action_pressed(InputNames.MOVE_LEFT):
		temp.x -= 1
	elif event.is_action_pressed(InputNames.MOVE_RIGHT):
		temp.x += 1
	elif event.is_action_pressed(InputNames.MOVE_UP):
		temp.y -= 1
	elif event.is_action_pressed(InputNames.MOVE_DOWN):
		temp.y += 1

	return temp

func _try_move(pos : Vector2i, old_pos : Vector2i):
	if _ref_DungeonGrid.is_legal_move(pos):
		if _ref_DungeonGrid.does_tile_contain_sprite(pos, TileTypes.DWARF):
			set_process_unhandled_input(false)
			get_node("PCAttack").attack(pos)
		else:
			_ref_DungeonGrid.move_sprite(old_pos, pos, _pc)
			_pc.position = ConvertCoords.get_local_coords(pos)
			print(ConvertCoords.get_world_coords(_pc.position))
		_ref_Schedule.end_turn()
