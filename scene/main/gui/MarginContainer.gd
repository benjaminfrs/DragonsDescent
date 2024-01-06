extends MarginContainer

func _ready():
	var left_edge_pos : float = ConvertCoords.START_X + (ConvertCoords.STEP_X * DungeonSize.MAX_X) + (ConvertCoords.STEP_X/2)
	#self.anchor_left = left_edge_pos / Globals.SCREEN_WIDTH
	var left_a : float = left_edge_pos / Globals.SCREEN_WIDTH
	self.anchor_left = left_a
	print(left_a, " ", left_edge_pos, " ", Globals.SCREEN_WIDTH, " ",self.anchor_left, " anchor!")
	self.anchor_right = 0.9
	self.anchor_top = 0.3
	self.anchor_bottom = 0.6
