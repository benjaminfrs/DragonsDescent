extends "res://lib/RootNodeTemplate.gd"

#game ready signal
signal game_ready()

#World references
const DUNGEON_GRID: String = "World/DungeonGrid"
const DWARF_MOVE: String = "World/DwarfMove"
const ENEMY_AI: String = "World/EnemyAI"
const INIT_WORLD: String = "World/InitWorld"
const PC_MOVE: String = "World/PCMove"
const PC_ATTACK: String = "World/PCMove/PCAttack"
const SCHEDULE: String = "World/Schedule"
const MAP_GENERATOR: String = "MapGenerator"
const WORLD: String = ""

#GUI references
const MODELINE: String = "MainGUI/MainHBox/ModeLine"
const SIDEBAR: String = "MainGUI/SidebarVBox"

const SIGNAL_BIND: Array = [
	[
		"illegal_move", "_on_DungeonGrid_illegal_move",
		DUNGEON_GRID,
		MODELINE,
	],
	[
		"sprite_created", "_on_InitWorld_sprite_created",
		INIT_WORLD,
		PC_MOVE, SCHEDULE, DUNGEON_GRID,
	],
	[
		"pc_attacked", "_on_PCAttack_pc_attacked",
		PC_ATTACK,
		MODELINE,
	],
	#[
	#	"tile_placed", "_on_MapGenerator_tile_placed",
	#	MAP_GENERATOR,
	#	INIT_WORLD,
	#],
	[
		"map_finished", "_on_MapGenerator_map_finished",
		MAP_GENERATOR,
		INIT_WORLD,
	],
	[
		"turn_started", "_on_Schedule_turn_started",
		SCHEDULE,
		ENEMY_AI, SIDEBAR,
	],
	[
		"turn_started_pc", "_on_Schedule_turn_started_pc",
		SCHEDULE,
		PC_MOVE
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
		"sprite_removed", "_on_DungeonGrid_sprite_removed",
		DUNGEON_GRID,
		SCHEDULE,
	],
	[
		"game_ready", "_on_Main_game_ready",
		WORLD,
		PC_MOVE, DUNGEON_GRID, MAP_GENERATOR,
	],
]

const NODE_REF: Array = [
	[
		"_ref_DungeonGrid",
		DUNGEON_GRID,
		PC_MOVE, PC_ATTACK, INIT_WORLD, DWARF_MOVE,
	],
	[
		"_ref_InitWorld",
		INIT_WORLD,
		DUNGEON_GRID,
	],
	[
		"_ref_Schedule",
		SCHEDULE,
		DWARF_MOVE, PC_MOVE, PC_ATTACK, ENEMY_AI,
	],
]

const LIB_REF: Array = [
]

func _init():
	super._init(SIGNAL_BIND, NODE_REF, LIB_REF)

func _ready():
	super._ready()
	emit_signal("game_ready")
