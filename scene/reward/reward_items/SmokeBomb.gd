extends ActorTemplate

signal used_item()
signal threw_bomb(smoke_effect)

const smoke_effect := preload("res://scene/reward/reward_items/smoke_bomb/smoke_effect_cpu_particles_2d.tscn")
const BASE_SMOKE_DUR = 4

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

var DirectionVectorScale = Vector2(ConvertCoords.STEP_X, ConvertCoords.STEP_Y)
var DirectionVectors = [
	Vector2.RIGHT * DirectionVectorScale, 
	Vector2.DOWN * DirectionVectorScale,
	Vector2.LEFT * DirectionVectorScale, 
	Vector2.UP * DirectionVectorScale,
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
	self.set_property("is_relic", true)

func equip(actor : Sprite2D) -> Array:
	self.set_property("equipped", true)
	return SMOKE_BOMB_SIGNALS #signals to connect to the actor that equips the item

func unequip(actor : Sprite2D):
	self.set_property("equipped", false)


func throw(source : Vector2i, event : InputEvent) -> bool:
	if not self.get_property("smoking"):
		print("Throwing!!!", source)
		var new_pos : Vector2
		for i in InputNames.MOVE_INPUTS.size():
			if event.is_action_pressed(InputNames.MOVE_INPUTS[i]):
				new_pos = DirectionVectors[i] + Vector2(ConvertCoords.get_local_coords(source))
				print("smoke pos:", new_pos, DirectionVectors[i], source)
		var smoke_particle_system = smoke_effect.instantiate()
		smoke_particle_system.set_grid_pos(new_pos)

		emit_signal("threw_bomb", smoke_particle_system)
		self.set_property("smoke_duration", BASE_SMOKE_DUR)
		self.set_property("current_effect", smoke_particle_system)
		self.set_property("smoking", true)
		return true
	return false

func update():
	if self.get_property("smoking"):
		self.set_property("smoke_duration", get_property("smoke_duration") - 1)
		if self.get_property("smoke_duration") <= 0:
			if self.get_property("current_effect") != null:
				self.get_property("current_effect").queue_free()
			self.set_property("smoking", false)

func use(actor : Sprite2D):
	print("used smoke bomb")
	#actor.set_property("invisible", true)
	#actor.get_property("status_list").append(["invisible", self.get_property("status_duration")])
	#emit_signal("used_item", "invisible", self.get_property("status_duration"), actor)

