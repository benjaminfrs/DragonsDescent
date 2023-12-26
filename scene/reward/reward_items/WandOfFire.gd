extends ActorTemplate

signal fired_wand(bolt)

const Bolt := preload("res://scene/reward/reward_items/wand_of_fire_bolts/WandOfFireBolt.tscn")

var DirectionAngles = [
	Vector2.RIGHT.angle(), 
	Vector2.DOWN.angle(),
	Vector2.LEFT.angle(), 
	Vector2.UP.angle(),
]

@onready var WAND_OF_FIRE_SIGNALS = [
	[
		"fired_wand", "_on_WandOfFire_fired_wand",
		self
	],
]

func _ready():
	self.scale = Vector2(1, 1)
	self.set_property("useable", true)
	self.set_property("consumable", false)
	self.set_property("type", TileTypes.WAND_OF_FIRE)
	self.set_property("equipped", false)
	self.set_property("ranged_weapon", true)
	self.set_property("is_relic", true)


func equip(actor : Sprite2D) -> Array:
	self.set_property("equipped", true)
	return WAND_OF_FIRE_SIGNALS #signals to connect to the actor that equips the item

func unequip(actor : Sprite2D):
	self.set_property("equipped", false)

#the calling actor will make itself invisible for 3 turns
func use(actor : Sprite2D):
	print("Used wand of fire!")
	#actor.set_property("invisible", true)
	#actor.get_property("status_list").append(["invisible", self.get_property("status_duration")])
	#emit_signal("used_item", "invisible", self.get_property("status_duration"), actor)
func shoot(source : Vector2i, event : InputEvent):
	print("SHOOTING!!!")
	var angle : float
	for i in InputNames.MOVE_INPUTS.size():
		if event.is_action_pressed(InputNames.MOVE_INPUTS[i]):
			angle = DirectionAngles[i]
			print("angle: ", angle)
	var bolt = Bolt.instantiate()
	bolt.transform = Transform2D(angle, Vector2(ConvertCoords.get_local_coords(source)))
	print(bolt.transform, bolt)
	
	emit_signal("fired_wand", bolt, bolt["BOLT_SIGNALS"])
