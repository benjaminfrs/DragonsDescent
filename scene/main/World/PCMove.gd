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
	var source: Array = ConvertCoords.vector_to_array(_pc.position)
	var target: Array

	if _is_move_input(event):
		target = _get_new_position(event, source)
		_try_move(target[0], target[1])

func _on_InitWorld_sprite_created(new_sprite: Sprite2D) -> void:
	if new_sprite.is_in_group(TileTypes.PC):
		_pc = new_sprite
		set_process_unhandled_input(true)


func _on_Schedule_turn_started(current_sprite: Sprite2D) -> void:
	if current_sprite.is_in_group(TileTypes.PC):
		set_process_unhandled_input(true)

func _is_move_input(event: InputEvent) -> bool:
	for m in _move_inputs:
		if event.is_action_pressed(m):
			return true
	return false


func _get_new_position(event: InputEvent, source: Array) -> Array:
	var x: int = source[0]
	var y: int = source[1]

	if event.is_action_pressed(InputNames.MOVE_LEFT):
		x -= 1
	elif event.is_action_pressed(InputNames.MOVE_RIGHT):
		x += 1
	elif event.is_action_pressed(InputNames.MOVE_UP):
		y -= 1
	elif event.is_action_pressed(InputNames.MOVE_DOWN):
		y += 1

	return [x, y]

func _try_move(x: int, y: int):
	if _ref_DungeonGrid.is_legal_move(x, y):
		if _ref_DungeonGrid.check_sprite_group_at_pos(x, y) == TileTypes.DWARF:
			set_process_unhandled_input(false)
			get_node("PCAttack").attack(x, y)
		else:
			_pc.position = ConvertCoords.index_to_vector(x, y)
		_ref_Schedule.end_turn()
