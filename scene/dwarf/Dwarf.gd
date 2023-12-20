extends ActorTemplate

#@onready var DWARF_MOVE = get_node("DwarfTestMove")
var DWARF_MOVE
const Scale = Vector2(2, 2)

func _ready():
	print(self, "READY")
	DWARF_MOVE = get_node("DwarfMove")
	print("dwarf_children: ", self.get_children())
	print(self.get_groups())
	$DwarfBody.add_to_group(TileTypes.DWARF + "_body")
	print($DwarfBody.get_groups(), $DwarfBody.get_children())
	self.set_property("in_smoke", false)
	$DwarfBody.entered_smoke.connect(self._on_DwarfBody_entered_smoke)
	$DwarfBody.exited_smoke.connect(self._on_DwarfBody_exited_smoke)


func setup(ref_DungeonGrid : Node2D, ref_Schedule : Node2D):
	DWARF_MOVE.setup(ref_DungeonGrid, ref_Schedule, self)
	self.add_to_group(TileTypes.DWARF)
	#self.scale = Scale

func take_turn():
	DWARF_MOVE.take_turn()
	print(self, " hit_box: ", $DwarfBody.global_position)
	print(self, " hit_box: ", $DwarfBody/DwarfHitBox.global_position)

func _on_DwarfBody_entered_smoke():
	self.set_property("in_smoke", true)

func _on_DwarfBody_exited_smoke():
	self.set_property("in_smoke", false)

