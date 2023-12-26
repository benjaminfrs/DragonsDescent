extends Sprite2D
class_name ActorTemplate

var _properties : Dictionary = {"throwable":false, "can_throw":false, "is_relic":false,}

func get_grid_pos() -> Vector2i:
	return ConvertCoords.get_world_coords(self.position)

func set_grid_pos(pos : Vector2i):
	self.position = ConvertCoords.get_local_coords(pos)

func get_property(prop : String):
	return _properties[prop]

func set_property(prop : String, value):
	_properties[prop] = value

func update():
	pass
