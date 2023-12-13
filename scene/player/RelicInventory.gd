extends Node

signal found_duplicate_relic(message)
signal equipped_duplicate_relic(message)
signal equipped_useable_relic(relic_type)

var _ref_DungeonGrid
var PlayerRelics = []
var EquippedRelics = []

func try_pickup_relic(relic : Sprite2D) -> bool:
	for player_relic in PlayerRelics:
		if player_relic.get_property("type") == relic.get_property("type"):
			emit_signal("found_duplicate_relic", "Don't be greedy!")
			return false
	PlayerRelics.append(relic)
	return true

func item_equipped(relic : Sprite2D) -> bool:
	for equipped_relic in EquippedRelics:
		if relic.get_property("ranged_weapon") and equipped_relic.get_property("ranged_weapon"):
			return false
		if equipped_relic.get_property("type") == relic.get_property("type"):
			emit_signal("equipped_duplicate_relic", "You can't wear more of those...")
			return false
	EquippedRelics.append(relic)
	if relic.get_property("useable"):
		emit_signal("equipped_useable_relic", relic.get_property("type"), relic)
	return true
