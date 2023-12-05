extends ActorTemplate

#@onready var DWARF_MOVE = get_node("DwarfTestMove")
var DWARF_MOVE
const Scale = Vector2(2, 2)

func _ready():
	print(self, "READY")
	DWARF_MOVE = get_node("DwarfMove")

func setup(ref_DungeonGrid : Node2D, ref_Schedule : Node2D):
	DWARF_MOVE.setup(ref_DungeonGrid, ref_Schedule, self)
	self.add_to_group(TileTypes.DWARF)
	#self.scale = Scale

func take_turn():
	DWARF_MOVE.take_turn()

