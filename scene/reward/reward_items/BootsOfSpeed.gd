extends ActorTemplate

func _ready():
	self.scale = Vector2(1, 1)
	self.set_property("movement_speed", 0)
	self.set_property("useable", false)
	self.set_property("consumable", false)
	self.set_property("type", TileTypes.BOOTS_OF_SPEED)
	self.set_property("ranged_weapon", false)
	self.set_property("is_relic", true)

func equip(actor : Sprite2D):
	actor.set_property("movement_speed", actor.get_property("movement_speed") + 1)
	return []

func unequip(actor : Sprite2D):
	actor.set_property("movement_speed", actor.get_property("movement_speed") - 1)
