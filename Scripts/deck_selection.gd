extends Control

var next_button: Button
var user_decks: ItemList
var example_decks: ItemList
var deck_settings: PackedScene

var selected_deck: String

func _ready() -> void:
	next_button = %Next
	user_decks = %UserDecks
	example_decks = %ExampleDecks
	deck_settings = preload("res://Scenes/deck_settings.tscn")
	
	Global.fill_list(user_decks, Global.get_user_decks().keys())
	Global.fill_list(example_decks, Global.get_example_decks().keys())
	

func _on_user_decks_item_selected(index: int) -> void:
	selected_deck = user_decks.get_item_text(index)
	if next_button.disabled:
		next_button.disabled = false
	

# Not implemented rn for simplicity
func _on_example_decks_item_selected(index: int) -> void:
	pass # Replace with function body.
	

func _on_next_button_down() -> void:
	# Start settings page
	var settings = deck_settings.instantiate()
	BackgroundManager.add_panel("Deck Settings", settings, 1)
	settings.set_variables(selected_deck)
	
