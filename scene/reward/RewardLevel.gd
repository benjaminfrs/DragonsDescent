extends Node2D

@onready var REWARD_GRID = self.get_node("RewardGrid")
@onready var SCHEDULE = self.get_node("Schedule")

@onready var PLAYER = Globals.Player
@onready var PC_MOVE = PLAYER.get_node("PCMove")
@onready var PC_ATTACK = PC_MOVE.get_node("PCAttack")
@onready var RELIC_INVENTORY = PLAYER.RELIC_INVENTORY

var REWARD_LEVEL = self

@onready var SIGNAL_BIND: Array = [
	[
		"ended_turn", "_on_Player_ended_turn",
		PLAYER,
		SCHEDULE,
	],
	[
		"shot_projectile", "_on_Player_shot_projectile",
		PLAYER,
		REWARD_GRID,
	],
	[
		"down_stairs", "_on_Player_down_stairs",
		PLAYER,
		REWARD_GRID,
	],
	[
		"sprite_created", "_on_DungeonGrid_sprite_created",
		REWARD_GRID,
		PC_MOVE, SCHEDULE,
	],
	[
		"item_picked_up", "_on_Player_item_picked_up",
		PLAYER,
		REWARD_GRID,
	],
	[
		"sprite_removed", "_on_DungeonGrid_sprite_removed",
		REWARD_GRID,
		SCHEDULE,
	],
]

@onready var NODE_REF: Array = [
	[
		"_ref_DungeonGrid",
		REWARD_GRID,
		PC_MOVE, PC_ATTACK, RELIC_INVENTORY,
	],
	[
		"_ref_Schedule",
		SCHEDULE,
		PC_MOVE, PC_ATTACK,
	],
]

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

func build_level():
	_set_signal(SIGNAL_BIND)
	_set_node_ref()
	REWARD_GRID.set_dungeon_size(4, 4)
	REWARD_GRID._init_dungeon()
	SCHEDULE.end_turn()

func _on_PCMove_down_stairs():
	pass

func close_level():
	self.remove_child(Globals.Player)
