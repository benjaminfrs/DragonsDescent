extends Label
var _turn_counter: int = 0
var _turn_text: String = "Turn: {0}"


func _ready() -> void:
	_update_turn()

func _on_Player_ended_turn():
	_turn_counter += 1
	_update_turn()


func _update_turn() -> void:
	self.text = _turn_text.format([_turn_counter])
