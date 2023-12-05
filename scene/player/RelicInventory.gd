extends Node

signal found_duplicate_relic(message)
signal equipped_duplicate_relic(message)

var _ref_DungeonGrid
var PlayerRelics = []
var EquippedRelics = []

func try_pickup_relic(relic : Sprite2D) -> bool:
	for player_relic in PlayerRelics:
		if player_relic.get_type() == relic.get_type():
			emit_signal("found_duplicate_relic", "Don't be greedy!")
			return false
	PlayerRelics.append(relic)
	return true

func item_equipped(relic : Sprite2D) -> bool:
	for equipped_relic in EquippedRelics:
		if equipped_relic.get_type() == relic.get_type():
			emit_signal("equipped_duplicate_relic", "You can't wear more of those...")
			return false
	EquippedRelics.append(relic)
	return true
