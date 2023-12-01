extends Node2D

var _level : int 

@onready var DUNGEON_GRID = self.get_node("DungeonGrid")
@onready var SCHEDULE = self.get_node("Schedule")

#@onready var DWARF_MOVE = self.get_node("DwarfMove")

@onready var PLAYER = Globals.Player
@onready var PC_MOVE = PLAYER.get_node("PCMove")
@onready var PC_ATTACK = PC_MOVE.get_node("PCAttack")

var WORLD = self

var dwarf_map = {}



@onready var SIGNAL_BIND: Array = [
	[
		"pc_killed_dwarf", "_on_PCAttack_pc_killed_dwarf",
		PC_ATTACK,
		DUNGEON_GRID,
	],
	[
		"turn_started_pc", "_on_Schedule_turn_started_pc",
		SCHEDULE,
		PC_MOVE,
	],
	[
		"pc_ended_turn", "_on_PCMove_pc_ended_turn",
		PC_MOVE,
		SCHEDULE,
	],
	[
		"down_stairs", "_on_PCMove_down_stairs",
		PC_MOVE,
		DUNGEON_GRID,
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
		"dwarf_placed", "_on_DungeonGrid_dwarf_placed",
		DUNGEON_GRID,
		WORLD,
	],
#	[
#		"dwarf_removed", "_on_DungeonGrid_dwarf_removed",
#		DUNGEON_GRID,
#		WORLD,
#	],
]

@onready var NODE_REF: Array = [
	[
		"_ref_DungeonGrid",
		DUNGEON_GRID,
		PC_MOVE, PC_ATTACK,
	],
	[
		"_ref_Schedule",
		SCHEDULE,
		PC_MOVE, PC_ATTACK,
	],
]

func _ready():
	pass
	#_set_path()
	#_set_signal()
	#_set_node_ref()

func _setup(level : int):
	_level = level
	DUNGEON_GRID._setup(_level)

func _set_signal(signals : Array):
	for s in signals:
		# [signal_name, func_name, source_node, target_node]
		for i in range(3, len(s)):
			#print("{source}[{signal_name}].connect({target}[{func}]".format(
			#	{"source":s[2], "signal_name":s[0], "target":s[i], "func":s[1]}))
			s[2][s[0]].connect(s[i][s[1]])

func _set_node_ref():
	for n in NODE_REF:
		# [target_var_name, source_node, target_node]
		for i in range(2, len(n)):
			#print("{target_node}[{target_name}] = {source}".format(
			#	{"target_node":n[i], "target_name":n[0], "source":n[1]}))
			#get_node(_get_path(n[i]))[n[0]] = get_node(_get_path(n[1]))
			n[i][n[0]] = n[1]

func build_level(map : Dictionary):
	_set_signal(SIGNAL_BIND)
	_set_node_ref()
	DUNGEON_GRID._init_dungeon(map)

func _on_DungeonGrid_dwarf_placed(dwarf : Sprite2D):
	#print("setting up da dwarf")
	dwarf.setup(DUNGEON_GRID, SCHEDULE)
	var SIGNALS_FOR_DWARVES: Array = [
		[
		"turn_started_dwarf", "_on_Schedule_turn_started_dwarf",
		SCHEDULE,
		dwarf.DWARF_MOVE,
		],
	]
	_set_signal(SIGNALS_FOR_DWARVES)
	

#func _on_DungeonGrid_dwarf_removed(dwarf : Node2D):
#	pass

func _on_PCMove_down_stairs():
	pass
#	print("HELLO!", self.get_children())
#	self.remove_child(Globals.Player)
#	print(self.get_children())

func close_level():
	#print("HELLO!", self.get_children())
	self.remove_child(Globals.Player)
	#print("closing level", self.get_children())
