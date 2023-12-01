extends Label

var health : int = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Your health is " + str(health)


func _on_DwarfMove_dwarf_attacks(message):
	health -= 1
	text = "Your health is " + str(health)
