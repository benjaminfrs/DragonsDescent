extends HBoxContainer

var skill_slots = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(6):
		var skill_slot = AssetLoader.SKILL_BAR.instantiate() as TextureRect
		self.add_child(skill_slot)
		skill_slots.append(skill_slot)
