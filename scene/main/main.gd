extends "res://lib/RootNodeTemplate.gd"
#extends Node

#game ready signal
signal game_ready()

#World references
const DUNGEON_GRID: String = "World/DungeonGrid"
const ENEMY_AI: String = "World/EnemyAI"
const INIT_WORLD: String = "World/InitWorld"
const PC_MOVE: String = "World/PCMove"
const PC_ATTACK: String = "World/PCMove/PCAttack"
const SCHEDULE: String = "World/Schedule"
const REMOVE_OBJECT: String = "World/RemoveObject"
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
	[
		"tile_placed", "_on_MapGenerator_tile_placed",
		MAP_GENERATOR,
		INIT_WORLD,
	],
	[
		"map_finished", "_on_MapGenerator_map_finished",
		MAP_GENERATOR,
		INIT_WORLD,
	],
	[
		"turn_started", "_on_Schedule_turn_started",
		SCHEDULE,
		ENEMY_AI, PC_MOVE, SIDEBAR,
	],
	[
		"turn_ended", "_on_Schedule_turn_ended",
		SCHEDULE,
		MODELINE,
	],
	[
		"sprite_removed", "_on_RemoveObject_sprite_removed",
		REMOVE_OBJECT,
		DUNGEON_GRID, SCHEDULE,
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
		PC_MOVE, PC_ATTACK, REMOVE_OBJECT,
	],
	[
		"_ref_InitWorld",
		INIT_WORLD,
		DUNGEON_GRID,
	],
	[
		"_ref_Schedule",
		SCHEDULE,
		PC_MOVE, PC_ATTACK, ENEMY_AI,
	],
	[
		"_ref_RemoveObject",
		REMOVE_OBJECT,
		PC_ATTACK,
	],
]

const LIB_REF: Array = [
	[
	"_new_ConvertCoords",
	"res://lib/ConvertCoords.gd",
	INIT_WORLD, PC_MOVE, DUNGEON_GRID,
	],
	[
	"_new_DungeonSize",
	"res://lib/DungeonSize.gd",
	INIT_WORLD, DUNGEON_GRID, MAP_GENERATOR,
	],
	[
	"_new_GroupName",
	"res://lib/GroupName.gd",
	INIT_WORLD, PC_MOVE, PC_ATTACK, SCHEDULE, ENEMY_AI, DUNGEON_GRID, MODELINE, SIDEBAR, MAP_GENERATOR,
	],
	[
	"_new_InputName",
	"res://lib/InputName.gd",
	INIT_WORLD, PC_MOVE,
	],
]

func _init():
	super._init(SIGNAL_BIND, NODE_REF, LIB_REF)

func _ready():
	super._ready()
	emit_signal("game_ready")
