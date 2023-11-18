extends Label

func _ready() -> void:
	text = "Press Space to start game."

func _on_Schedule_turn_ended(current_sprite: Sprite2D):
	if current_sprite.is_in_group(TileTypes.PC):
		pass
		#text = ""

func _on_DungeonGrid_illegal_move(message: String):
	text = message

func _on_PCAttack_pc_attacked(message: String):
	text = message
