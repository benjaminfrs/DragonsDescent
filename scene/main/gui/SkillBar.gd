extends HBoxContainer

var skill_slots = []
var relics = []
# Called when the node enters the scene tree for the first time.
#func _ready():
#	for i in range(6):
#		var skill_slot = AssetLoader.SKILL_BAR.instantiate() as TextureRect
#		self.add_child(skill_slot)
#		skill_slots.append(skill_slot)

func _on_RelicInventory_equipped_useable_relic(relic_type : String, relic : Sprite2D):
	var skill_slot = AssetLoader.SKILL_BAR.instantiate() as TextureRect
	var asset_name = relic_type + "_icon"
	skill_slot.set_texture(load(AssetLoader[asset_name]))
	skill_slots.append(skill_slot)
	relics.append(relic)
	self.add_child(skill_slot)

func _on_Player_pressed_skill(skill_ind : int):
	if relics.size() > skill_ind:
		relics[skill_ind].use(Globals.Player)
