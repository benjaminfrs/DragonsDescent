extends Node2D

const Schedule := preload("res://scene/main/World/Schedule.gd")
var _ref_Schedule: Schedule

const DungeonGrid := preload("res://scene/main/World/DungeonGrid.gd")
var _ref_DungeonGrid: DungeonGrid

var _new_ConvertCoord := preload("res://lib/ConvertCoords.gd").new()
var _new_InputName := preload("res://lib/InputName.gd").new()
var _new_GroupName := preload("res://lib/GroupName.gd").new()

var _pc: Sprite2D

var _move_inputs: Array = [
	_new_InputName.MOVE_LEFT,
	_new_InputName.MOVE_RIGHT,
	_new_InputName.MOVE_UP,
	_new_InputName.MOVE_DOWN,
]

func _ready() -> void:
	set_process_unhandled_input(false)

func _unhandled_input(event: InputEvent) -> void:
	var source: Array = _new_ConvertCoord.vector_to_array(_pc.position)
	var target: Array

	if _is_move_input(event):
		target = _get_new_position(event, source)
		_try_move(target[0], target[1])

func _on_InitWorld_sprite_created(new_sprite: Sprite2D) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_pc = new_sprite
		set_process_unhandled_input(true)


func _on_Schedule_turn_started(current_sprite: Sprite2D) -> void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		set_process_unhandled_input(true)

func _is_move_input(event: InputEvent) -> bool:
	for m in _move_inputs:
		if event.is_action_pressed(m):
			return true
	return false


func _get_new_position(event: InputEvent, source: Array) -> Array:
	var x: int = source[0]
	var y: int = source[1]

	if event.is_action_pressed(_new_InputName.MOVE_LEFT):
		x -= 1
	elif event.is_action_pressed(_new_InputName.MOVE_RIGHT):
		x += 1
	elif event.is_action_pressed(_new_InputName.MOVE_UP):
		y -= 1
	elif event.is_action_pressed(_new_InputName.MOVE_DOWN):
		y += 1

	return [x, y]

func _try_move(x: int, y: int) -> void:
	if _ref_DungeonGrid.is_legal_move(x, y):
		if _ref_DungeonGrid.check_sprite_group_at_pos(x, y) == _new_GroupName.DWARF:
			set_process_unhandled_input(false)
			get_node("PCAttack").attack(x, y)
		else:
			_pc.position = _new_ConvertCoord.index_to_vector(x, y)
		_ref_Schedule.end_turn()
