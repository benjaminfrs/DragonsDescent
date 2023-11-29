class_name AssetLoader

const Player := preload("res://sprite/pc.tscn")
const Dwarf := preload("res://sprite/d_sprite.tscn")
const Floor := preload("res://sprite/floor_sprite.tscn")
const xArrow := preload("res://sprite/x_sprite.tscn")
const yArrow := preload("res://sprite/y_sprite.tscn")
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

static func get_asset(groupName: String) -> PackedScene:
	if groupName == "blwall":
		return Blwall
	if groupName == "failed":
		return Failed
	if groupName == "lewall":
		return Lewall
	if groupName == "rewall":
		return Rewall
	if groupName == "uewall":
		return Uewall
	if groupName == "brwall":
		return Brwall
	if groupName == "bewall":
		return Bewall
	if groupName == "ulwall":
		return Ulwall
	if groupName == "urwall":
		return Urwall
	if groupName == ("wall"):
		return Wall
	if groupName == "dwarf":
		return Dwarf
	if groupName == "floor":
		return Floor
	return null
