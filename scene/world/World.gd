extends Node2D

var _level : int 

@onready var DUNGEON_GRID = self.get_node("DungeonGrid")
@onready var SCHEDULE = self.get_node("Schedule")
@onready var PC_MOVE = self.get_node("PCMove")
@onready var DWARF_MOVE = self.get_node("DwarfMove")
@onready var PC_ATTACK = PC_MOVE.get_node("PCAttack")



@onready var SIGNAL_BIND: Array = [
	[
		"down_stairs", "_on_PCMove_down_stairs",
		PC_MOVE,
		DUNGEON_GRID,
	],
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
		"turn_started_dwarf", "_on_Schedule_turn_started_dwarf",
		SCHEDULE,
		DWARF_MOVE
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
]

@onready var NODE_REF: Array = [
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

func _ready():
	pass
	#_set_path()
	#_set_signal()
	#_set_node_ref()

func _setup(level : int):
	_level = level
	DUNGEON_GRID._setup(_level)

#func _set_path():
#	_path_to_self = get_path()


#func _set_signal():
#	for s in _signal_bind:
#		# [signal_name, func_name, source_node, target_node]
#		for i in range(3, len(s)):
#			print("get_node({source}).{signal_name}.connect(get_node({target}).{func})".format(
#				{"source":_get_path(s[2]), "signal_name":s[0], "target":_get_path(s[i]), "func":s[1]}))
#			get_node(_get_path(s[2]))[s[0]].connect(get_node(_get_path(s[i]))[s[1]])

func _set_signal():
	for s in SIGNAL_BIND:
		# [signal_name, func_name, source_node, target_node]
		for i in range(3, len(s)):
			print("{source}[{signal_name}].connect({target}[{func}]".format(
				{"source":s[2], "signal_name":s[0], "target":s[i], "func":s[1]}))
			s[2][s[0]].connect(s[i][s[1]])

#func _set_node_ref():
#	for n in _node_ref:
#		# [target_var_name, source_node, target_node]
#		for i in range(2, len(n)):
#			print("get_node(_get_path({target_node}))[{target_name}] = get_node(_get_path({source}))".format(
#				{"target_node":n[i], "target_name":n[0], "source":n[1]}))
#			get_node(_get_path(n[i]))[n[0]] = get_node(_get_path(n[1]))

func _set_node_ref():
	for n in NODE_REF:
		# [target_var_name, source_node, target_node]
		for i in range(2, len(n)):
			print("{target_node}[{target_name}] = {source}".format(
				{"target_node":n[i], "target_name":n[0], "source":n[1]}))
			#get_node(_get_path(n[i]))[n[0]] = get_node(_get_path(n[1]))
			n[i][n[0]] = n[1]

func build_level(map : Dictionary):
	_set_signal()
	_set_node_ref()
	DUNGEON_GRID._init_dungeon(map)
