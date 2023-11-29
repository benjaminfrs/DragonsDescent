extends "res://lib/RootNodeTemplate.gd"

#game ready signal
signal game_ready()
signal map_ready(map)

const world_scene = preload("res://resource/World.tscn")

#World references
const DUNGEON_GRID: String = "World/DungeonGrid"
const DWARF_MOVE: String = "World/DwarfMove"
const PC_MOVE: String = "World/PCMove"
const PC_ATTACK: String = "World/PCMove/PCAttack"
const SCHEDULE: String = "World/Schedule"
const MAP_GENERATOR: String = "MapGenerator"
const WORLD: String = ""
const world_test: String = "World"

#GUI references
const HEALTHLINE: String = "MainGUI/MainHBox/HealthLine"
const MODELINE: String = "MainGUI/MainHBox/ModeLine"
const SIDEBAR: String = "MainGUI/SidebarVBox"

const SIGNAL_BIND: Array = [
	[
		"illegal_move", "_on_DungeonGrid_illegal_move",
		DUNGEON_GRID,
		MODELINE,
	],
	[
		"pc_attacked", "_on_PCAttack_pc_attacked",
		PC_ATTACK,
		MODELINE,
	],
	[
		"pc_killed_dwarf", "_on_PCAttack_pc_killed_dwarf",
		PC_ATTACK,
		DUNGEON_GRID,
	],
	[
		"dwarf_attacks", "_on_DwarfMove_dwarf_attacks",
		DWARF_MOVE,
		MODELINE, HEALTHLINE,
	],
#	[
#		"map_finished", "_on_MapGenerator_map_finished",
#		MAP_GENERATOR,
#		DUNGEON_GRID,
#	],
	#[
	#	"turn_started", "_on_Schedule_turn_started",
	#	SCHEDULE,
	#	SIDEBAR,
	#],
	[
		"turn_started_pc", "_on_Schedule_turn_started_pc",
		SCHEDULE,
		PC_MOVE, SIDEBAR,
	],
	[
		"turn_started_dwarf", "_on_Schedule_turn_started_dwarf",
		SCHEDULE,
		DWARF_MOVE
	],
	[
		"turn_ended", "_on_Schedule_turn_ended",
		SCHEDULE,
		MODELINE,
	],
	[
		"sprite_created", "_on_DungeonGrid_sprite_created",
		DUNGEON_GRID,
		PC_MOVE, SCHEDULE,
	],
	[
		"sprite_removed", "_on_DungeonGrid_sprite_removed",
		DUNGEON_GRID,
		SCHEDULE,
	],
	[
		"game_ready", "_on_Main_game_ready",
		WORLD,
		PC_MOVE, DUNGEON_GRID, MAP_GENERATOR,
	],
#	[
#		"map_ready", "_on_Main_map_ready",
#		WORLD,
#		DUNGEON_GRID,
#	],
]

const NODE_REF: Array = [
	[
		"_ref_DungeonGrid",
		DUNGEON_GRID,
		PC_MOVE, PC_ATTACK, DWARF_MOVE,
	],
	[
		"_ref_Schedule",
		SCHEDULE,
		DWARF_MOVE, PC_MOVE, PC_ATTACK,
	],
]

const LIB_REF: Array = [
]

func _init():
	pass
	#super._init(SIGNAL_BIND, NODE_REF, LIB_REF)

func _ready():
	super._init(SIGNAL_BIND, NODE_REF, LIB_REF)
	super._ready()
	emit_signal("game_ready")
	var map = get_node("MapGenerator").generate()
	#emit_signal("map_ready", map)
	get_node(world_test)._setup(1)
	get_node(DUNGEON_GRID).dungeon_complete.connect(_on_DungeonGrid_dungeon_complete)
	get_node("World/DungeonGrid")._init_dungeon(map)
	print(self.get_children())
	var new_world = world_scene.instantiate()
	add_child(new_world)
	print(self.get_children())
	print(get_node(world_test).get_children(false))
	print(new_world.get_children())
	print(new_world.get_node("DungeonGrid"))

	#self.remove_child(get_node(world_test))
	#new_world.build_level(get_node("MapGenerator").generate())

func _on_DungeonGrid_dungeon_complete():
	print("Level finished!")

	
