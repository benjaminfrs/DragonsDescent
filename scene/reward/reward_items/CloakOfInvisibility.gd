extends ActorTemplate

const _TYPE = "CloakOfInvisibility"
var _equipped = false

func _ready():
	self.scale = Vector2(1, 1)

func equip(actor : Sprite2D):
	pass

func unequip(actor : Sprite2D):
	pass

func get_type() -> String:
	return _TYPE

func is_equipped() -> bool:
	return _equipped
