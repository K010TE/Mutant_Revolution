extends Control


func _ready():
	for button in get_tree().get_nodes_in_group("button"):
		button.connect("pressed", Callable(self, "on_button_pressed").bind(button))
		button.connect("mouse_exited", Callable(self, "mouse_interaction").bind(button, "exited"))
		button.connect("mouse_entered", Callable(self, "mouse_interaction").bind(button, "entered"))


func on_button_pressed(button: Button):
	match button.name:
		"Play":
			var _game: bool = get_tree().change_scene_to_file("res://scenes/game_level.tscn")
		
		"Quit":
			get_tree().quit()
			
func mouse_interaction(button: Button, state: String):
	match state:
		"exited":
			button.modulate.a = 1.0
			
		"entered":
			button.modulate.a = 0.5
			
func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			print("Screen touched at: ", event.position)
		else:
			print("Touch released at: ", event.position)
