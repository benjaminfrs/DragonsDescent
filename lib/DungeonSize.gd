class_name DungeonSize

const MAX_X: int = 10
const MAX_Y: int = 10

const CENTER_X: int = 10
const CENTER_Y: int = 7

#const ARROW_MARGIN: int = 32

static func is_inside_dungeon(pos : Vector2i) -> bool:
	if pos.x < 0 or pos.x >= MAX_X:
		return false
	if pos.y < 0 or pos.y >= MAX_Y:
		return false
	return true

static func get_valid_dirs(pos : Vector2i) -> Array:
	var dirs = []
	
	for d in TileRules.Directions:
		if DungeonSize.is_inside_dungeon(pos + TileRules.Directions[d]):
			dirs.append(d)
	return dirs
