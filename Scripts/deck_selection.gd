extends Control

var next_button: Button
var user_decks: ItemList
var example_decks: ItemList

var selected_deck: String

func _ready() -> void:
	next_button = %Next
	user_decks = %UserDecks
	example_decks = %ExampleDecks
	
	fill_lists(user_decks, Global.get_user_decks().keys())
	fill_lists(example_decks, Global.get_example_decks().keys())
	

func fill_lists(deck_list: ItemList, keys: Array) -> void:
	for key in keys:
		deck_list.add_item(key)
		print(keys)
	

func _on_user_decks_item_selected(index: int) -> void:
	selected_deck = user_decks.get_item_text(index)
	if next_button.disabled:
		next_button.disabled = false
	

# Not implemented rn for simplicity
func _on_example_decks_item_selected(index: int) -> void:
	pass # Replace with function body.
	

func _on_next_button_down() -> void:
	# TODO: start sentence page
	pass
