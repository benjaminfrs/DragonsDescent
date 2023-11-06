extends Node2D

const DungeonGrid := preload("res://scene/main/DungeonGrid.gd")
var _ref_DungeonGrid: DungeonGrid
const Schedule := preload("res://scene/main/Schedule.gd")
var _ref_Schedule: Schedule
const RemoveObject := preload("res://scene/main/RemoveObject.gd")
var _ref_RemoveObject: RemoveObject

var _new_GroupName := preload("res://lib/GroupName.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attack(x: int, y: int):
	print("You swing at the dwarf!")
	_ref_RemoveObject.remove(x, y)
