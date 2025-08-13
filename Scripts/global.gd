extends Node

func _ready() -> void:
#	Set the screen size
	get_window().size = DisplayServer.screen_get_size() / 2
	get_window().move_to_center()
