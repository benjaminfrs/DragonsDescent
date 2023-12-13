class_name AssetLoader

const Player := preload("res://sprite/pc.tscn")
const Dwarf := preload("res://scene/dwarf/dwarf.tscn")
const Floor := preload("res://sprite/floor_sprite.tscn")
const Wall := preload("res://sprite/wall_sprite.tscn")
const Ulwall := preload("res://sprite/ulwall_sprite.tscn")
const Urwall := preload("res://sprite/urwall_sprite.tscn")
const Brwall := preload("res://sprite/brwall_sprite.tscn")
const Blwall := preload("res://sprite/blwall_sprite.tscn")
const Bewall := preload ("res://sprite/bewall_sprite.tscn")
const Uewall := preload ("res://sprite/uewall_sprite.tscn")
const Rewall := preload ("res://sprite/rewall_sprite.tscn")
const Lewall := preload ("res://sprite/lewall_sprite.tscn")
const Failed := preload("res://sprite/failed_sprite.tscn")
const DownStairs := preload("res://sprite/stair_down_sprite.tscn")
const ItemHolder := preload("res://sprite/test_item.tscn")
const BootsOfSpeed := preload("res://scene/reward/reward_items/BootsOfSpeed.tscn")
const CloakOfInvisibility := preload("res://scene/reward/reward_items/CloakOfInvisibility.tscn")
const WandOfFire := preload("res://scene/reward/reward_items/WandOfFire.tscn")
const cloak_of_invisibility_reward_icon = "res://resource/textures/cloak_of_invisibility_icon.png"
const wand_of_fire_reward_icon = "res://resource/textures/wand_of_fire_icon.png"

const SKILL_BAR := preload("res://scene/ui_elements/skill_slot.tscn")

static func get_asset(groupName: String) -> PackedScene:
	if groupName == TileTypes.BLWALL:
		return Blwall
	if groupName == "failed":
		return Failed
	if groupName == TileTypes.LEWALL:
		return Lewall
	if groupName == TileTypes.REWALL:
		return Rewall
	if groupName == TileTypes.UEWALL:
		return Uewall
	if groupName == TileTypes.BRWALL:
		return Brwall
	if groupName == TileTypes.BEWALL:
		return Bewall
	if groupName == TileTypes.ULWALL:
		return Ulwall
	if groupName == TileTypes.URWALL:
		return Urwall
	if groupName == TileTypes.WALL:
		return Wall
	if groupName == TileTypes.DWARF:
		return Dwarf
	if groupName == TileTypes.FLOOR:
		return Floor
	if groupName == TileTypes.ITEM_HOLDER:
		return ItemHolder
	if groupName == TileTypes.BOOTS_OF_SPEED:
		return BootsOfSpeed
	if groupName == TileTypes.CLOAK_OF_INVISIBILITY:
		return CloakOfInvisibility
	if groupName == TileTypes.WAND_OF_FIRE:
		return WandOfFire
	return null

const RewardItems = [BootsOfSpeed]
