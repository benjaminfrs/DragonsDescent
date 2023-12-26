extends Button

signal main_screen_pressed()

func _ready():
	self.button_down.connect(self._on_MainScreenButton_button_pressed)

func _on_MainScreenButton_button_pressed():
	emit_signal("main_screen_pressed")
