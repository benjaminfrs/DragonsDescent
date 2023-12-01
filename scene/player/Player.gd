extends ActorTemplate

signal player_created(pc)

const Scale = Vector2(2, 2)
var PC_MOVE
var PC_ATTACK

# Called when the node enters the scene tree for the first time.
func setup_player():
	print("Player ready!")
	self.scale = Scale
	self.add_to_group(TileTypes.PC)
	emit_signal("player_created", self)
	PC_MOVE = get_node("PCMove")
	PC_MOVE._setup(self)
	PC_ATTACK = PC_MOVE.get_node("PCAttack")

func get_pc() -> Sprite2D:
	return self

func take_turn():
	PC_MOVE.take_turn()
