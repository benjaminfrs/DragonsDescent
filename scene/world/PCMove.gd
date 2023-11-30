extends Node2D

signal down_stairs(pos)

var _ref_Schedule
var _ref_DungeonGrid

var _pc: Sprite2D
var _move_inputs: Array

func _ready() -> void:
	set_process_unhandled_input(false)
	_move_inputs = [
		InputNames.MOVE_LEFT,
		InputNames.MOVE_RIGHT,
		InputNames.MOVE_UP,
		InputNames.MOVE_DOWN,
	]

func _on_Main_game_ready():
	pass


func _unhandled_input(event: InputEvent) -> void:
	var source: Vector2i = ConvertCoords.get_world_coords(_pc.position)
	if event.is_action_pressed(InputNames.WAIT):
		_ref_Schedule.end_turn()
	if event.is_action_pressed(InputNames.GO_DOWN):
		emit_signal("down_stairs", ConvertCoords.get_world_coords(_pc.position))
	if _is_move_input(event):
		_try_move(_get_new_position(event, source), source)

func _on_DungeonGrid_sprite_created(new_sprite: Sprite2D) -> void:
	if new_sprite.is_in_group(TileTypes.PC):
		_pc = new_sprite
		set_process_unhandled_input(true)


func _on_Schedule_turn_started_pc(current_sprite: Sprite2D) -> void:
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

func _try_move(new_pos : Vector2i, old_pos : Vector2i):
	if _ref_DungeonGrid.is_legal_move(new_pos):
		if _ref_DungeonGrid.does_tile_contain_sprite(new_pos, TileTypes.DWARF):
			get_node("PCAttack").attack(new_pos)
		else:
			_ref_DungeonGrid.move_sprite(old_pos, new_pos, _pc)
			_pc.position = ConvertCoords.get_local_coords(new_pos)
		set_process_unhandled_input(false)
		_ref_Schedule.end_turn()
