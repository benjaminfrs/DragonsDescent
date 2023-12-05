extends ActorTemplate

signal player_created(pc)
signal down_stairs(pos)
signal ended_turn()
signal took_action()
signal item_picked_up(item)

const Scale = Vector2(1.5, 1.5)
var PC_MOVE
var PC_ATTACK
var RELIC_INVENTORY
var SELF
var _movement_speed = 1
var _current_energy = _movement_speed
var _most_recent_key : InputEvent

#const move_inputs = [
#		InputNames.MOVE_LEFT,
#		InputNames.MOVE_RIGHT,
#		InputNames.MOVE_UP,
#		InputNames.MOVE_DOWN,
#	]

# Called when the node enters the scene tree for the first time.
func setup_player():
	print("Player ready!")
	self.scale = Scale
	self.add_to_group(TileTypes.PC)
	emit_signal("player_created", self)
	PC_MOVE = get_node("PCMove")
	RELIC_INVENTORY = get_node("RelicInventory")
	SELF = self
	PC_MOVE._setup(self)
	PC_ATTACK = PC_MOVE.get_node("PCAttack")
	self.set_process_unhandled_input(false)

func get_pc() -> Sprite2D:
	return self

func take_turn():
	#print("Player taking turn - current energy: ", _current_energy)
	#self.set_process_unhandled_input(true)
	_current_energy = _movement_speed
	self.set_process_unhandled_input(true)
	while _current_energy:
		#print("Player taking turn - current energy: ", _current_energy)
		await self.took_action

	_current_energy = _movement_speed
	self.set_process_unhandled_input(false)
	emit_signal("ended_turn")

func _on_Main_game_ready():
	pass

func _unhandled_input(event: InputEvent) -> void:
	var source: Vector2i = ConvertCoords.get_world_coords(self.position)
	if event.is_action_pressed(InputNames.WAIT):
		self.set_process_unhandled_input(false)
		emit_signal("ended_turn")
	if event.is_action_pressed(InputNames.GO_DOWN):
		_current_energy -= 1
		emit_signal("down_stairs", ConvertCoords.get_world_coords(self.position))
	if _is_move_input(event):
		if not try_get(source, event):
			if PC_MOVE.try_move(source, event):
				_current_energy -= 1
	_most_recent_key = event
	emit_signal("took_action")

func try_get(source : Vector2i, event : InputEvent) -> bool:
	if _most_recent_key and _most_recent_key.is_action(InputNames.GET):
		print("trying to pickup")
		var item = PC_MOVE.try_pickup(source, event) as Sprite2D
		print(item)
		if item and item.get_groups().any(func(group):
			for relic_type in TileTypes.reward_items:
				if group == relic_type:
					return true
			return false
			):
			if RELIC_INVENTORY.try_pickup_relic(item):
				emit_signal("item_picked_up", item)
				RELIC_INVENTORY.add_child(item)
				item.visible = false
				if RELIC_INVENTORY.item_equipped(item):
					item.equip(self)
				return true
	return false

func _on_DungeonGrid_sprite_created(new_sprite: Sprite2D) -> void:
	pass
#	if new_sprite.is_in_group(TileTypes.PC):
#		#_pc = new_sprite
#		self.set_process_unhandled_input(true)


func _is_move_input(event: InputEvent) -> bool:
	for m in InputNames.MOVE_INPUTS:
		if event.is_action_pressed(m):
			return true
	return false
