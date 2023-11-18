extends Node2D

var _ref_DungeonGrid

signal sprite_removed(remove_sprite, x, y)

func remove(x: int, y: int):
	var sprite: Sprite2D = _ref_DungeonGrid.get_sprite_at_pos(x, y)

	emit_signal("sprite_removed", sprite, x, y)
	sprite.queue_free()
