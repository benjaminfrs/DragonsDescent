extends Button

signal game_start_pressed()

func _ready():
	self.button_down.connect(self._on_StartGameButton_button_pressed)

func _on_StartGameButton_button_pressed():
	emit_signal("game_start_pressed")
