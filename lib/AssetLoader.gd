class_name AssetLoader

const dwarf := preload("res://scene/dwarf/dwarf.tscn")
const floor := preload("res://sprite/floor_sprite.tscn")
const wall := preload("res://sprite/wall_sprite.tscn")
const ulwall := preload("res://sprite/ulwall_sprite.tscn")
const urwall := preload("res://sprite/urwall_sprite.tscn")
const brwall := preload("res://sprite/brwall_sprite.tscn")
const blwall := preload("res://sprite/blwall_sprite.tscn")
const bewall := preload ("res://sprite/bewall_sprite.tscn")
const uewall := preload ("res://sprite/uewall_sprite.tscn")
const rewall := preload ("res://sprite/rewall_sprite.tscn")
const lewall := preload ("res://sprite/lewall_sprite.tscn")
const down_stairs := preload("res://sprite/stair_down_sprite.tscn")
const item_holder := preload("res://sprite/test_item.tscn")
const boots_of_speed_reward := preload("res://scene/reward/reward_items/BootsOfSpeed.tscn")
const cloak_of_invisibility_reward := preload("res://scene/reward/reward_items/CloakOfInvisibility.tscn")
const wand_of_fire_reward := preload("res://scene/reward/reward_items/WandOfFire.tscn")
const smoke_bomb_reward := preload("res://scene/reward/reward_items/SmokeBomb.tscn")
const dragons_lamp_reward := preload("res://scene/reward/reward_items/DragonsLamp.tscn")

const cloak_of_invisibility_reward_icon = "res://resource/textures/cloak_of_invisibility_icon.png"
const wand_of_fire_reward_icon = "res://resource/textures/wand_of_fire_icon.png"
const smoke_bomb_reward_icon = "res://resource/textures/smoke_bomb_icon.png"

const SKILL_BAR := preload("res://scene/ui_elements/skill_slot.tscn")

static func get_asset(type: String) -> PackedScene:
	return AssetLoader[type]
