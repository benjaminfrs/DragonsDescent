extends Node2D

func _ready():
	pass
#	get_node("DungeonGrid").illegal_move.connect($MainGUI/MainHBox/ModeLine._on_DungeonGrid_illegal_move)

	#get_node("InitWorld").sprite_created.connect(get_node("PCMove")._on_InitWorld_sprite_created)
	#get_node("InitWorld").sprite_created.connect(get_node("Schedule")._on_InitWorld_sprite_created)
	#get_node("InitWorld").sprite_created.connect(get_node("DungeonGrid")._on_InitWorld_sprite_created)

#	#$PCMove/PCAttack.pc_attacked.connect($MainGUI/MainHBox/ModeLine._on_PCAttack_pc_attacked)

	#get_node("Schedule").turn_started.connect(get_node("PCMove")._on_Schedule_turn_started)
	#get_node("Schedule").turn_started.connect(get_node("EnemyAI")._on_Schedule_turn_started)
#	#get_node("Schedule").turn_started.connect($MainGUI/SidebarVBox._on_Schedule_turn_started)
#	#get_node("Schedule").turn_ended.connect($MainGUI/MainHBox/ModeLine._on_Schedule_turn_ended)

	#get_node("RemoveObject").sprite_removed.connect(get_node("DungeonGrid")._on_RemoveObject_sprite_removed)
	#get_node("RemoveObject").sprite_removed.connect(get_node("Schedule")._on_RemoveObject_sprite_removed)

	#get_node("DungeonGrid")._ref_InitWorld = get_node("InitWorld")

	#get_node("PCMove")._ref_Schedule = get_node("Schedule")
	#get_node("EnemyAI")._ref_Schedule = get_node("Schedule")
	#$PCMove/PCAttack._ref_Schedule = get_node("Schedule")

	#get_node("PCMove")._ref_DungeonGrid = get_node("DungeonGrid")
	#$PCMove/PCAttack._ref_DungeonGrid = get_node("DungeonGrid")
	#get_node("RemoveObject")._ref_DungeonGrid = get_node("DungeonGrid")

	#$PCMove/PCAttack._ref_RemoveObject = get_node("RemoveObject")
