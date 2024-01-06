extends Node

const PlayerScene = preload("res://scene/player/player.tscn")

var Player
@onready var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/viewport_height")
@onready var SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/viewport_width")
# Called when the node enters the scene tree for the first time.
func setup_globals():
	print("setting globals")
	Player = PlayerScene.instantiate()
	Player.setup_player()
