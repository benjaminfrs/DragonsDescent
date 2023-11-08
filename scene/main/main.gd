extends Node

func _ready():
	get_node("World/DungeonGrid").illegal_move.connect(get_node("MainGUI/MainHBox/ModeLine")._on_DungeonGrid_illegal_move)

	get_node("World/InitWorld").sprite_created.connect(get_node("World/PCMove")._on_InitWorld_sprite_created)
	get_node("World/InitWorld").sprite_created.connect(get_node("World/Schedule")._on_InitWorld_sprite_created)
	get_node("World/InitWorld").sprite_created.connect(get_node("World/DungeonGrid")._on_InitWorld_sprite_created)

	$World/PCMove/PCAttack.pc_attacked.connect(get_node("MainGUI/MainHBox/ModeLine")._on_PCAttack_pc_attacked)

	get_node("World/Schedule").turn_started.connect(get_node("World/PCMove")._on_Schedule_turn_started)
	get_node("World/Schedule").turn_started.connect(get_node("World/EnemyAI")._on_Schedule_turn_started)
	get_node("World/Schedule").turn_started.connect(get_node("MainGUI/SidebarVBox")._on_Schedule_turn_started)

	get_node("World/Schedule").turn_ended.connect(get_node("MainGUI/MainHBox/ModeLine")._on_Schedule_turn_ended)

	get_node("World/RemoveObject").sprite_removed.connect(get_node("World/DungeonGrid")._on_RemoveObject_sprite_removed)
	get_node("World/RemoveObject").sprite_removed.connect(get_node("World/Schedule")._on_RemoveObject_sprite_removed)

	get_node("World/DungeonGrid")._ref_InitWorld = get_node("World/InitWorld")

	get_node("World/PCMove")._ref_Schedule = get_node("World/Schedule")
	get_node("World/EnemyAI")._ref_Schedule = get_node("World/Schedule")
	$World/PCMove/PCAttack._ref_Schedule = get_node("World/Schedule")

	get_node("World/PCMove")._ref_DungeonGrid = get_node("World/DungeonGrid")
	$World/PCMove/PCAttack._ref_DungeonGrid = get_node("World/DungeonGrid")
	get_node("World/RemoveObject")._ref_DungeonGrid = get_node("World/DungeonGrid")

	$World/PCMove/PCAttack._ref_RemoveObject = get_node("World/RemoveObject")
