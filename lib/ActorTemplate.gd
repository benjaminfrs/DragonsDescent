extends Sprite2D
class_name ActorTemplate


func get_grid_pos() -> Vector2i:
	return ConvertCoords.get_world_coords(self.position)

func set_grid_pos(pos : Vector2i):
	self.position = ConvertCoords.get_local_coords(pos)
