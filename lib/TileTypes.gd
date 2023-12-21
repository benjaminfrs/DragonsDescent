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

const REWARD: String = "reward"
const ITEM_HOLDER: String = "item_holder"
const RELIC: String = "relic"
const BOOTS_OF_SPEED: String = "boots_of_speed_reward"
const CLOAK_OF_INVISIBILITY: String = "cloak_of_invisibility_reward"
const WAND_OF_FIRE: String = "wand_of_fire_reward"
const SMOKE_BOMB: String = "smoke_bomb_reward"
const DRAGONS_LAMP: String = "dragons_lamp_reward"

const reward_items = [BOOTS_OF_SPEED, CLOAK_OF_INVISIBILITY, WAND_OF_FIRE, SMOKE_BOMB, DRAGONS_LAMP]
const mapTileNames: Array = [DWARF, FLOOR, WALL, ULWALL, BLWALL, URWALL, BRWALL, BEWALL, LEWALL, REWALL, UEWALL]
const basic_tiles: Array = [FLOOR, WALL, ULWALL, URWALL, BLWALL, BRWALL, BEWALL, LEWALL, REWALL, UEWALL]
const actor_types: Array = [DWARF, PC]

static func is_sprite_actor(sprite : Sprite2D) -> bool:
	for group in sprite.get_groups():
		if actor_types.find(group) > -1:
			return true
	return false

static func object_group_fuzzy_search(obj, fuzz_word : String) -> bool:
	for group in obj.get_groups():
		if group.contains(fuzz_word):
			return true
	return false
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
