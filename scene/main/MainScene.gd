extends Node2D

func _ready():
	get_node("InitWorld").sprite_created.connect(get_node("PCMove")._on_InitWorld_sprite_created)
