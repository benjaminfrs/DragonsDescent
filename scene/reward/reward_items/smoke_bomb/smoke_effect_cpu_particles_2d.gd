extends CPUParticles2D

func _ready():
	$SmokeArea.add_to_group("SmokeBombArea")

func set_grid_pos(pos : Vector2):
	self.position = pos
