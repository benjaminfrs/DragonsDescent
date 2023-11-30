extends "res://lib/RootNodeTemplate.gd"

#game ready signal
signal game_ready()
signal map_ready(map)

const world_scene = preload("res://scene/world/World.tscn")
var current_level : Node2D

##World references
const DUNGEON_GRID: String = "DUNGEON_GRID"
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
#	[
#		"pc_killed_dwarf", "_on_PCAttack_pc_killed_dwarf",
#		PC_ATTACK,
#		DUNGEON_GRID,
#	],
	[
		"dwarf_attacks", "_on_DwarfMove_dwarf_attacks",
		DWARF_MOVE,
		MODELINE, HEALTHLINE,
	],
##	[
##		"map_finished", "_on_MapGenerator_map_finished",
##		MAP_GENERATOR,
##		DUNGEON_GRID,
##	],
#	[
#		"turn_started", "_on_Schedule_turn_started_pc",
#		SCHEDULE,
#		SIDEBAR,
#	],
	[
		"turn_started_pc", "_on_Schedule_turn_started_pc",
		SCHEDULE,
		SIDEBAR,
	],
#	[
#		"turn_started_dwarf", "_on_Schedule_turn_started_dwarf",
#		SCHEDULE,
#		DWARF_MOVE
#	],
	[
		"turn_ended", "_on_Schedule_turn_ended",
		SCHEDULE,
		MODELINE,
	],
	[
		"dungeon_complete", "_on_DungeonGrid_dungeon_complete",
		DUNGEON_GRID,
		MAIN,
	],
#	[
#		"sprite_created", "_on_DungeonGrid_sprite_created",
#		DUNGEON_GRID,
#		PC_MOVE, SCHEDULE,
#	],
#	[
#		"sprite_removed", "_on_DungeonGrid_sprite_removed",
#		DUNGEON_GRID,
#		SCHEDULE,
#	],
#	[
#		"game_ready", "_on_Main_game_ready",
#		WORLD,
#		PC_MOVE, DUNGEON_GRID, MAP_GENERATOR,
#	],
##	[
##		"map_ready", "_on_Main_map_ready",
##		WORLD,
##		DUNGEON_GRID,
##	],
]
#
#const NODE_REF: Array = [
#	[
#		"_ref_DungeonGrid",
#		DUNGEON_GRID,
#		PC_MOVE, PC_ATTACK, DWARF_MOVE,
#	],
#	[
#		"_ref_Schedule",
#		SCHEDULE,
#		DWARF_MOVE, PC_MOVE, PC_ATTACK,
#	],
#]
#
#const LIB_REF: Array = [
#]

func _init():
	pass
	#super._init(SIGNAL_BIND, NODE_REF, LIB_REF)

func _ready():
	_setup_level()

func _on_DungeonGrid_dungeon_complete():
	print("Level finished!")
	#current_level[DUNGEON_GRID].place_stairs()
	

func _setup_level():
	current_level = world_scene.instantiate()
	add_child(current_level)
	current_level._setup(1)
	_setup_signals_for_level(current_level)

	#print(self.get_children())
	#print(get_node(world_test).get_children(false))
	print(current_level.get_children())
	print(current_level.get_node("DungeonGrid"))

	#self.remove_child(get_node(world_test))
	current_level.build_level(get_node("MapGenerator").generate())
	#current_level.DUNGEON_GRID["dungeon_complete"].connect(_on_DungeonGrid_dungeon_complete)

func _setup_signals_for_level(node : Node2D):
	for s in SIGNAL_BIND:
		for i in range(3, len(s)):
			node[s[2]][s[0]].connect(get_node(s[i])[s[1]])
