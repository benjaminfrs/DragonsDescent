extends ActorTemplate

signal used_item(status, duration, actor)

const _TYPE = "CloakOfInvisibility"
var _equipped = false

var INVISIBILITY_CLOAK_SIGNALS = [
	[
		"used_item", "_on_CloakOfInvisibility_used_item",
		self
	],
]

func _ready():
	self.scale = Vector2(1, 1)
	self.set_property("type", TileTypes.CLOAK_OF_INVISIBILITY)
	self.set_property("equipped", false)
	self.set_property("useable", true)
	self.set_property("consumable", false)
	self.set_property("status_duration", 3)

func equip(actor : Sprite2D) -> Array:
	self.set_property("equipped", true)
	return INVISIBILITY_CLOAK_SIGNALS #signals to connect to the actor that equips the item

func unequip(actor : Sprite2D):
	self.set_property("equipped", false)

#the calling actor will make itself invisible for 3 turns
func use(actor : Sprite2D):
	#actor.set_property("invisible", true)
	#actor.get_property("status_list").append(["invisible", self.get_property("status_duration")])
	emit_signal("used_item", "invisible", self.get_property("status_duration"), actor)
