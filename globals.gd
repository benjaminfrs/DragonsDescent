extends Node

const PlayerScene = preload("res://scene/player/player.tscn")

var Player
# Called when the node enters the scene tree for the first time.
func setup_globals():
	print("setting globals")
	Player = PlayerScene.instantiate()
	Player.setup_player()
