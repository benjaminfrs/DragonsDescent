extends Area2D

signal entered_smoke()
signal exited_smoke()

func _ready():
	self.area_entered.connect(self._on_DwarfBody_area_entered)
	self.area_exited.connect(self._on_DwarfBody_area_exited)

func _on_DwarfBody_area_entered(body):
	if body.is_in_group("SmokeBombArea"):
		print("dwarf entered", body)
		emit_signal("entered_smoke")

func _on_DwarfBody_area_exited(body):
	if body.is_in_group("SmokeBombArea"):
		print("dwarf exited", body)
		emit_signal("exited_smoke")
