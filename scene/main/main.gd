extends "res://lib/RootNodeTemplate.gd"

#game ready signal
signal game_ready()
signal map_ready(map)

const world_scene = preload("res://scene/world/World.tscn")
const reward_scene = preload("res://scene/reward/RewardMain.tscn")
const game_gui = preload("res://scene/main/gui/MainGUI.tscn")
const start_screen_gui = preload("res://scene/main/gui/start_screen/StartScreen.tscn")

var current_level : Node2D
var level_ind : int = 2

const PLAYER: String = "SELF"
const PLAYER_REF: = "Player"
const PC_MOVE: String = "PC_MOVE"
const PC_ATTACK: String = "PC_ATTACK"
const RELIC_INVENTORY: String = "RELIC_INVENTORY"
##World references
const DUNGEON_GRID: String = "DUNGEON_GRID"
const REWARD_GRID: String = "REWARD_GRID"
const DWARF_MOVE: String = "DWARF_MOVE"
const SCHEDULE: String = "SCHEDULE"
#const MAP_GENERATOR: String = "MapGenerator"
const MAIN: String = "/root/Main"
#const world_test: String = "World"
#
#GUI references
const HEALTHLINE: String = "MainGUI/MarginContainer/MainHBox/VBoxContainer/HealthLine"
const MODELINE: String = "MainGUI/MarginContainer/MainHBox/ModeLine"
const TURN_LINE: String = "MainGUI/MarginContainer/MainHBox/VBoxContainer/TurnLine"
const SKILL_BAR: String = "MainGUI/TextureRect/MarginContainer/SkillBar"
#
const SIGNAL_BIND_LEVEL: Array = [
	[
		"illegal_move", "_on_DungeonGrid_illegal_move",
		DUNGEON_GRID,
		MODELINE,
	],
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
		"ended_turn", "_on_Player_ended_turn",
		PLAYER,
		TURN_LINE,
	],
	[
		"pressed_skill", "_on_Player_pressed_skill",
		PLAYER,
		SKILL_BAR,
	],
	[
		"found_lamp", "_on_Player_found_lamp",
		PLAYER,
		MAIN,
	],
	[
		"found_duplicate_relic", "_on_RelicInventory_found_duplicate_relic",
		RELIC_INVENTORY,
		MODELINE,
	],
	[
		"equipped_duplicate_relic", "_on_RelicInventory_equipped_duplicate_relic",
		RELIC_INVENTORY,
		MODELINE,
	],
	[
		"equipped_useable_relic", "_on_RelicInventory_equipped_useable_relic",
		RELIC_INVENTORY,
		SKILL_BAR,
	],
]

const SIGNAL_BIND_DWARVES = [
	[
		"dwarf_attacks", "_on_DwarfMove_dwarf_attacks",
		DWARF_MOVE,
		MODELINE, HEALTHLINE,
	],
]

func _ready():
	var start_screen = start_screen_gui.instantiate()
	self.add_child(start_screen)
	start_screen.get_node("MarginContainer/VBoxContainer/StartGameButton").game_start_pressed.connect(self._on_StartGameButton_game_start_pressed)

func _on_StartGameButton_game_start_pressed():
	self.get_node("StartScreen").queue_free()
	self.add_child(game_gui.instantiate())
	Globals.setup_globals()
	_setup_signals(Globals.Player, SIGNAL_BIND_PLAYER)
	_build_next_level()

func _on_DungeonGrid_leaving_dungeon():
	print("Leaving dungeon!")
	_build_next_level()

func _build_next_level():
	if current_level:
		current_level.close_level()
		current_level.queue_free()
		
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

func _on_Player_found_lamp():
	print("You found the lamp!!! GAME OVER")
	get_tree().quit()

func _setup_signals(node : Node2D, signals : Array):
# [signal_name, func_name, source_node, target_node]
	for s in signals:
		for i in range(3, len(s)):
			#print(node[s[2]])

			node[s[2]][s[0]].connect(get_node(s[i])[s[1]])
