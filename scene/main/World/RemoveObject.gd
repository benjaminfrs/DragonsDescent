extends Node2D

const DungeonGrid := preload("res://scene/main/World/DungeonGrid.gd")
var _ref_DungeonGrid: DungeonGrid

signal sprite_removed(remove_sprite, x, y)

func remove(x: int, y: int):
	var sprite: Sprite2D = _ref_DungeonGrid.get_sprite_at_pos(x, y)

	emit_signal("sprite_removed", sprite, x, y)
	sprite.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
