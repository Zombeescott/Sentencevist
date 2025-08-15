extends Node

var user_decks: Dictionary
var example_decks: Dictionary
var user_progress: Array

func _ready() -> void:
	set_screen_size()
	

# Set the screen size
func set_screen_size() -> void:
	get_window().size = DisplayServer.screen_get_size() / 2
	get_window().move_to_center()
	

func set_decks(user: Dictionary, example: Dictionary) -> void:
	user_decks = user
	example_decks = example
	# TODO: also progress
	

func get_user_decks() -> Dictionary:
	return user_decks
	

func get_example_decks() -> Dictionary:
	return example_decks
	
