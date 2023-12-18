extends ActorTemplate

signal used_item()
signal threw_bomb(smoke_effect)

const smoke_effect := preload("res://scene/reward/reward_items/smoke_bomb/smoke_effect_cpu_particles_2d.tscn")
const BASE_SMOKE_DUR = 3

@onready var SMOKE_BOMB_SIGNALS = [
	[
		"used_item", "_on_SmokeBomb_used_item",
		self
	],
	[
		"threw_bomb", "_on_SmokeBomb_threw_bomb",
		self
	],
]

var DirectionAngles = [
	Vector2.RIGHT.angle(), 
	Vector2.DOWN.angle(),
	Vector2.LEFT.angle(), 
	Vector2.UP.angle(),
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
	self.set_property("throwable", true)
	self.set_property("smoking", false)

func equip(actor : Sprite2D) -> Array:
	self.set_property("equipped", true)
	return SMOKE_BOMB_SIGNALS #signals to connect to the actor that equips the item

func unequip(actor : Sprite2D):
	self.set_property("equipped", false)


func throw(source : Vector2i, event : InputEvent):
	print("Throwing!!!")
	var angle : float
	for i in InputNames.MOVE_INPUTS.size():
		if event.is_action_pressed(InputNames.MOVE_INPUTS[i]):
			angle = DirectionAngles[i]
			print("angle: ", angle)
	var smoke_particle_system = smoke_effect.instantiate()
	smoke_particle_system.transform = Transform2D(angle, Vector2(ConvertCoords.get_local_coords(source)))
	print(smoke_particle_system.transform, smoke_particle_system)
	emit_signal("threw_bomb", smoke_particle_system)
	self.set_property("smoke_duration", BASE_SMOKE_DUR)
	self.set_property("current_effect", smoke_particle_system)
	self.set_property("smoking", true)

func update():
	if self.get_property("smoking"):
		self.set_property("smoke_duration", get_property("smoke_duration") - 1)
		if self.get_property("smoke_duration") <= 0:
			self.get_property("current_effect").queue_free()
			self.set_property("smoking", false)

func use(actor : Sprite2D):
	print("used smoke bomb")
	#actor.set_property("invisible", true)
	#actor.get_property("status_list").append(["invisible", self.get_property("status_duration")])
	#emit_signal("used_item", "invisible", self.get_property("status_duration"), actor)

