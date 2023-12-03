extends "res://lib/RootNodeTemplate.gd"

#game ready signal
signal game_ready()
signal map_ready(map)

const world_scene = preload("res://scene/world/World.tscn")
const reward_scene = preload("res://scene/reward/RewardMain.tscn")

var current_level : Node2D
var level_ind : int = 1

##World references
const DUNGEON_GRID: String = "DUNGEON_GRID"
const REWARD_GRID: String = "REWARD_GRID"
const DWARF_MOVE: String = "DWARF_MOVE"
const PC_MOVE: String = "PC_MOVE"
const PC_ATTACK: String = "PC_ATTACK"
const SCHEDULE: String = "SCHEDULE"
#const MAP_GENERATOR: String = "MapGenerator"
const MAIN: String = "/root/Main"
#const world_test: String = "World"
#
#GUI references
const HEALTHLINE: String = "MainGUI/MainHBox/HealthLine"
const MODELINE: String = "MainGUI/MainHBox/ModeLine"
const SIDEBAR: String = "MainGUI/SidebarVBox"
#
const SIGNAL_BIND_LEVEL: Array = [
	[
		"illegal_move", "_on_DungeonGrid_illegal_move",
		DUNGEON_GRID,
		MODELINE,
	],
	[
		"turn_started_pc", "_on_Schedule_turn_started_pc",
		SCHEDULE,
		SIDEBAR,
	],
	[
		"turn_ended", "_on_Schedule_turn_ended",
		SCHEDULE,
		MODELINE,
	],
#	[
#		"dungeon_complete", "_on_DungeonGrid_dungeon_complete",
#		DUNGEON_GRID,
#		MAIN,
#	],
	[
		"leaving_dungeon", "_on_DungeonGrid_leaving_dungeon",
		DUNGEON_GRID,
		MAIN,
	],
	[
		"dwarf_placed", "_on_DungeonGrid_dwarf_placed",
		DUNGEON_GRID,
		MAIN,
	],
]

const SIGNAL_BIND_REWARD_LEVEL: Array = [
	[
		"illegal_move", "_on_DungeonGrid_illegal_move",
		REWARD_GRID,
		MODELINE,
	],
#	[
#		"turn_started_pc", "_on_Schedule_turn_started_pc",
#		SCHEDULE,
#		SIDEBAR,
#	],
#	[
#		"turn_ended", "_on_Schedule_turn_ended",
#		SCHEDULE,
#		MODELINE,
#	],
	[
		"leaving_dungeon", "_on_DungeonGrid_leaving_dungeon",
		REWARD_GRID,
		MAIN,
	],
]

const SIGNAL_BIND_PLAYER = [
	[
		"pc_attacked", "_on_PCAttack_pc_attacked",
		PC_ATTACK,
		MODELINE,
	],
	[
		"pc_ended_turn", "_on_PCMove_pc_ended_turn",
		PC_MOVE,
		SIDEBAR,
	],
]

const SIGNAL_BIND_DWARVES = [
	[
		"dwarf_attacks", "_on_DwarfMove_dwarf_attacks",
		DWARF_MOVE,
		MODELINE, HEALTHLINE,
	],
]

func _init():
	pass
	#super._init(SIGNAL_BIND, NODE_REF, LIB_REF)

func _ready():
	Globals.setup_globals()
	_setup_signals(Globals.Player, SIGNAL_BIND_PLAYER)
	#_setup_dungeon_level()
	_build_next_level()

#func _on_DungeonGrid_dungeon_complete():
#	print("Level finished!")

func _on_DungeonGrid_leaving_dungeon():
	print("Leaving dungeon!")
	_build_next_level()

func _build_next_level():
	if current_level:
		current_level.close_level()
		current_level.free()
		
	if not level_ind % 2:
		_setup_reward_level()
	else:
		_setup_dungeon_level()
	level_ind += 1


func _on_DungeonGrid_dwarf_placed(dwarf : Sprite2D):
	_setup_signals(dwarf, SIGNAL_BIND_DWARVES)

func _setup_dungeon_level():
	current_level = world_scene.instantiate()
	current_level.add_child(Globals.Player)
	add_child(current_level)
	current_level._setup(level_ind)
	_setup_signals(current_level, SIGNAL_BIND_LEVEL)

	current_level.build_level(get_node("MapGenerator").generate())

func _setup_reward_level():
	current_level = reward_scene.instantiate()
	current_level.add_child(Globals.Player)
	add_child(current_level)
	_setup_signals(current_level, SIGNAL_BIND_REWARD_LEVEL)

	current_level.build_level()

func _setup_signals(node : Node2D, signals : Array):
	for s in signals:
		for i in range(3, len(s)):
			#print(node[s[2]])

			node[s[2]][s[0]].connect(get_node(s[i])[s[1]])
