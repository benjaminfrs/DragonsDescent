extends Node2D

signal pc_attacked(message)

var _ref_DungeonGrid
var _ref_Schedule
var _ref_RemoveObject

var _new_GroupName

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attack(x: int, y: int):
	emit_signal("pc_attacked", "You swing at the dwarf!")
	_ref_RemoveObject.remove(x, y)
