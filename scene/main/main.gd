extends "res://lib/RootNodeTemplate.gd"

#game ready signal
signal game_ready()

#World references
const DUNGEON_GRID: String = "World/DungeonGrid"
const DWARF_MOVE: String = "World/DwarfMove"
const PC_MOVE: String = "World/PCMove"
const PC_ATTACK: String = "World/PCMove/PCAttack"
const SCHEDULE: String = "World/Schedule"
const MAP_GENERATOR: String = "MapGenerator"
const WORLD: String = ""

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
		"dwarf_attacks", "_on_DwarfMove_dwarf_attacks",
		DWARF_MOVE,
		MODELINE, HEALTHLINE,
	],
	[
		"map_finished", "_on_MapGenerator_map_finished",
		MAP_GENERATOR,
		DUNGEON_GRID,
	],
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
	super._init(SIGNAL_BIND, NODE_REF, LIB_REF)

func _ready():
	super._ready()
	emit_signal("game_ready")
