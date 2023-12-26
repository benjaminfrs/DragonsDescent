extends ActorTemplate

signal player_created(pc)
signal down_stairs(pos)
signal ended_turn()
signal took_action()
signal item_picked_up(item)
signal pressed_skill(skill_ind)
signal shot_projectile(bolt, signals)
signal created_particle_effect(effect)
signal found_lamp()

enum {STATUS, STATUS_DURATION}

const Scale = Vector2(1.5, 1.5)
var PC_MOVE
var PC_ATTACK
var RELIC_INVENTORY
var SELF
var _movement_speed = 1
var _current_energy : int
var _most_recent_key : InputEvent


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
	self.set_property("movement_speed", 1)
	self.set_property("invisible", false)
	self.set_property("status_list", [])
	self.set_property("can_shoot", false)
	self.set_process_unhandled_input(false)

#func set_status(status : Array):
#

func get_pc() -> Sprite2D:
	return self

func take_turn():
	#print("Player taking turn - current energy: ", _current_energy)
	#self.set_process_unhandled_input(true)
	_current_energy = _properties["movement_speed"]
	self.set_process_unhandled_input(true)
	self.process_status()
	while _current_energy:
		#print("Player taking turn - current energy: ", _current_energy)
		await self.took_action

	#_current_energy = _movement_speed

	self.set_process_unhandled_input(false)
	for item in RELIC_INVENTORY.EquippedRelics:
		item.update()
	emit_signal("ended_turn")

func process_status():
	for status in self.get_property("status_list"):
		status[STATUS_DURATION] -= 1
		if status[STATUS_DURATION] == 0:
			var end_status_func = "_end_" + status[STATUS]
			var callable = Callable(self, end_status_func)
			callable.call(status)


func _end_invisible(status):
	self.set_property(status[STATUS], false)
	self.get_property("status_list").erase(status)
	self.self_modulate.a = 1

func _on_Main_game_ready():
	pass

func _unhandled_input(event: InputEvent) -> void:
	var source: Vector2i = ConvertCoords.get_world_coords(self.position)
	if event.is_action_pressed(InputNames.WAIT):
		self.set_process_unhandled_input(false)
		_current_energy = 0
		#emit_signal("ended_turn")
	if event.is_action_pressed(InputNames.GO_DOWN):
		_current_energy -= 1
		emit_signal("down_stairs", ConvertCoords.get_world_coords(self.position))
	var skill_ind = _is_skill_input(event)
	if skill_ind > -1:
		emit_signal("pressed_skill", skill_ind)
	if _is_dir_input(event):
		if _most_recent_key:
			if _most_recent_key.is_action(InputNames.SHOOT):
				if try_shoot(source, event):
					_current_energy -= 1
					emit_signal("took_action")
			elif _most_recent_key.is_action(InputNames.THROW):
				print("trying to throw!")
				if try_throw(source, event):
					_current_energy -= 1
			elif not try_get(source, event):
				if PC_MOVE.try_move(source, event):
					_current_energy -= 1
	_most_recent_key = event
	emit_signal("took_action")

func try_throw(source : Vector2i, event : InputEvent) -> bool:
	if self.get_property("can_throw"):
		if self.get_property("throwable_item").throw(source, event):
			return true
	return false

func try_shoot(source : Vector2i, event : InputEvent) -> bool:
	if self.get_property("can_shoot"):
		print("Preparing to shoot wand!")
		self.get_property("equipped_wand").shoot(source, event)
		return true
	return false

func try_get(source : Vector2i, event : InputEvent) -> bool:
	if _most_recent_key and _most_recent_key.is_action(InputNames.GET):
		print("trying to pickup")
		var item = PC_MOVE.try_pickup(source, event) as Sprite2D
		print(item)
#		if item and item.get_groups().any(func(group):
#			for relic_type in TileTypes.reward_items:
#				if group == relic_type:
#					return true
#			return false
#			):
		if item and item.get_property("is_relic"):
			if RELIC_INVENTORY.try_pickup_relic(item):
				emit_signal("item_picked_up", item)
				RELIC_INVENTORY.add_child(item)
				item.visible = false
				if RELIC_INVENTORY.item_equipped(item):
					if item.get_property("type") == TileTypes.DRAGONS_LAMP:
						emit_signal("found_lamp")
					var item_signals = item.equip(self)
					_setup_item_signals(item_signals)
					if item.get_property("ranged_weapon"):
						self.set_property("can_shoot", true)
						self.set_property("equipped_wand", item)
						print(self.get_property("can_shoot"))
					if item.get_property("throwable"):
						self.set_property("can_throw", true)
						self.set_property("throwable_item", item)
		return true
	return false

func _on_DungeonGrid_sprite_created(new_sprite: Sprite2D) -> void:
	pass
#	if new_sprite.is_in_group(TileTypes.PC):
#		#_pc = new_sprite
#		self.set_process_unhandled_input(true)

func _on_CloakOfInvisibility_used_item(status : String, status_duration : int, actor : Sprite2D):
	if self == actor:
		self.set_property(status, true)
		self.get_property("status_list").append([status, status_duration])
		self.self_modulate.a = 0.33

func _on_SmokeBomb_used_item():
	print("Player uses smoke bomb")

func _on_SmokeBomb_threw_bomb(smoke_effect):
	print("Player uses smoke bomb")
	emit_signal("created_particle_effect", smoke_effect)

func _on_WandOfFire_fired_wand(bolt : Area2D, signals : Array):
	print(bolt)
	emit_signal("shot_projectile", bolt, signals)

func _is_dir_input(event: InputEvent) -> bool:
	for m in InputNames.MOVE_INPUTS:
		if event.is_action_pressed(m):
			return true
	return false

func _is_skill_input(event : InputEvent) -> int:
	for input_ind in InputNames.SKILL_INPUTS.size():
		if event.is_action_pressed(InputNames.SKILL_INPUTS[input_ind]):
			return input_ind
	return -1

func _setup_item_signals(signals : Array):
	#['signal_name', 'function_name', item]
	for s in signals:
		for i in range(2, len(s)):
			#print(node[s[2]])
			s[i][s[0]].connect(self[s[1]])
