class_name TileTypes extends Object

const DWARF: String = "dwarf"
const PC: String = "pc"

const FLOOR: String = "floor"

#Wall groups represent possible wall tiles for map generator
#surrounded wall
const WALL: String = "wall"
#upper left
const ULWALL: String = "ulwall"
#bottom left
const BLWALL: String = "blwall"
#upper right
const URWALL: String = "urwall"
#bottom right
const BRWALL: String = "brwall"
#bottom edge
const BEWALL: String = "bewall"
#left edge
const LEWALL: String = "lewall"
#right edge
const REWALL: String = "rewall"
#upper edge
const UEWALL: String = "uewall"

const DOWN_STAIRS: String = "down_stairs"

const ARROW: String = "arrow"

const mapTileNames: Array = [DWARF, FLOOR, WALL, ULWALL, BLWALL, URWALL, BRWALL, BEWALL, LEWALL, REWALL, UEWALL]
const basic_tiles: Array = [FLOOR, WALL, ULWALL, URWALL, BLWALL, BRWALL, BEWALL, LEWALL, REWALL, UEWALL]
const actor_types: Array = [DWARF, PC]
#const basic_tile_weights = {
#	FLOOR : 0.35,
#	WALL : 0.05,
#	ULWALL : 0.1,
#	URWALL : 0.1,
#	BLWALL : 0.1,
#	BRWALL : 0.1,
#	LEWALL : 0.05,
#	REWALL : 0.05,
#	BEWALL : 0.05,
#	UEWALL : 0.05
#}
const basic_tile_weights = {
	FLOOR : 0.45,
	WALL : 0.2,
	ULWALL : 0.025,
	URWALL : 0.025,
	BLWALL : 0.025,
	BRWALL : 0.025,
	LEWALL : 0.05,
	REWALL : 0.05,
	BEWALL : 0.05,
	UEWALL : 0.05,
}
