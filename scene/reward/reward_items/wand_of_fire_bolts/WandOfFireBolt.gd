extends Area2D

signal dwarf_hit(dwarf)

#["signal_name", self reference]
var BOLT_SIGNALS = [
	[
		"dwarf_hit",
		self
	]
]

@export var speed = 250

func _ready():
	self.area_entered.connect(self._on_Bolt_area_entered)
	#self.area_exited.connect(self._on_Bolt_area_exited)
	print(self.position)

func _physics_process(delta):
	position += transform.x * speed * delta
	print("bolt position: ", position, " | player pos: ", Globals.Player.position, " overlapping bodies: ", self.get_overlapping_areas())


func _on_Bolt_area_entered(body):
	if body.get_parent().is_in_group(TileTypes.DWARF):
		emit_signal("dwarf_hit", body.get_parent())
		self.queue_free()
	if TileTypes.object_group_fuzzy_search(body.get_parent(), "wall") \
	or TileTypes.object_group_fuzzy_search(body, "OutOfBounds"):
		print("body entered!", body.get_groups())
		#body.queue_free()
		self.queue_free()

#func _on_Bolt_area_exited(body):
#
#	if body.is_in_group("DungeonGridArea"):
#		print("body exited! freeing", body)
#		self.queue_free()
