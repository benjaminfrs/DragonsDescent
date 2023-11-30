extends Label

var health : int = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Your health is " + str(health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _on_DwarfMove_dwarf_attacks(message):
#	health -= 1
#	text = "Your health is " + str(health)
