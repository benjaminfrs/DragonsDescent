extends Node2D

func _ready():
	get_node("InitWorld").sprite_created.connect(get_node("PCMove")._on_InitWorld_sprite_created)
	get_node("InitWorld").sprite_created.connect(get_node("Schedule")._on_InitWorld_sprite_created)
	get_node("Schedule").turn_started.connect(get_node("PCMove")._on_Schedule_turn_started)
	get_node("Schedule").turn_started.connect(get_node("EnemyAI")._on_Schedule_turn_started)
	
	get_node("PCMove")._ref_Schedule = get_node("Schedule")
	get_node("EnemyAI")._ref_Schedule = get_node("Schedule")
