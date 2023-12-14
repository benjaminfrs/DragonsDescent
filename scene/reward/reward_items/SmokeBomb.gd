extends ActorTemplate

signal used_item()

@onready var SMOKE_BOMB_SIGNALS = [
	[
		"used_item", "_on_SmokeBomb_used_item",
		self
	],
]

func _ready():
	self.scale = Vector2(1, 1)
	self.set_property("type", TileTypes.SMOKE_BOMB)
	self.set_property("equipped", false)
	self.set_property("useable", true)
	self.set_property("consumable", true)
	self.set_property("stack_size", 3)
	self.set_property("status_duration", 3)
	self.set_property("ranged_weapon", false)

func equip(actor : Sprite2D) -> Array:
	self.set_property("equipped", true)
	return SMOKE_BOMB_SIGNALS #signals to connect to the actor that equips the item

func unequip(actor : Sprite2D):
	self.set_property("equipped", false)

#the calling actor will make itself invisible for 3 turns
func use(actor : Sprite2D):
	print("used smoke bomb")
	#actor.set_property("invisible", true)
	#actor.get_property("status_list").append(["invisible", self.get_property("status_duration")])
	#emit_signal("used_item", "invisible", self.get_property("status_duration"), actor)

