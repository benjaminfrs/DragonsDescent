extends VBoxContainer

var _turn_counter: int = 0
var _turn_text: String = "Turn: {0}"

@onready var _label_help: Label = get_node("Help")
@onready var _label_turn: Label = get_node("Turn")


func _ready() -> void:
	_label_help.text = "RL !!!!"
	_update_turn()


func _on_Schedule_turn_started_pc(current_sprite: Sprite2D):
	if current_sprite.is_in_group(TileTypes.PC):
		_turn_counter += 1
		_update_turn()


func _update_turn() -> void:
	_label_turn.text = _turn_text.format([_turn_counter])
