extends ActorTemplate

const _TYPE = "BootsOfSpeed"

func _ready():
	self.scale = Vector2(0.5, 0.5)

func equip(actor : Sprite2D):
	actor._movement_speed += 1

func unequip(actor : Sprite2D):
	actor._movement_speed -= 1

func get_type() -> String:
	return _TYPE
