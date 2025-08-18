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
	

# Called only by save_manager when it is ready
func set_decks(user: Dictionary, example: Dictionary) -> void:
	user_decks = user
	example_decks = example
	# TODO: also progress
	

# Refresh global variables
func refresh() -> void:
	user_decks = SaveManager.load_user_deck()
	example_decks = SaveManager.load_example_deck()
	

func get_user_decks() -> Dictionary:
	return user_decks
	

func get_example_decks() -> Dictionary:
	return example_decks
	

# Utility function that fills a given ItemList (For names)
func fill_list(deck_list: ItemList, keys: Array) -> void:
	for key in keys:
		deck_list.add_item(key)
	

# Utility function that fills a given ItemList (For Sentences)
func fill_list_sentences(deck_list: ItemList, sentences: Dictionary) -> void:
	for key in sentences:
		deck_list.add_item(key + ", " + sentences.get(key))
	
