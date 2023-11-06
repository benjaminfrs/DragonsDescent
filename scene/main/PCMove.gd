extends Node2D

const Schedule := preload("res://scene/main/Schedule.gd")
var _ref_Schedule: Schedule

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
		_pc.position = _new_ConvertCoord.index_to_vector(
				target[0], target[1])

		set_process_unhandled_input(false)
		_ref_Schedule.end_turn()

func _on_InitWorld_sprite_created(new_sprite: Sprite2D) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_pc = new_sprite
		set_process_unhandled_input(true)


func _on_Schedule_turn_started(current_sprite: Sprite2D) -> void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		set_process_unhandled_input(true)
	else:
		print(current_sprite.name)

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
