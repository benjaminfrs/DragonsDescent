class_name ConvertCoords

const START_X: int = 240
const START_Y: int = 140
const STEP_X: int = 48
const STEP_Y: int = 48

static func get_world_coords(pos : Vector2i) -> Vector2i:
	var v = Vector2i(((pos.x - START_X) / STEP_X), ((pos.y - START_Y) / STEP_Y))
	return v

static func get_local_coords(pos : Vector2i, x_offset : int = 0, y_offset : int = 0) -> Vector2i:
	return Vector2i(START_X + STEP_X * pos.x + x_offset, START_Y + STEP_Y * pos.y + y_offset)
