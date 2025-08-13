extends Control

var deck_label: Label
var total_label: Label
var final_list: ItemList

func _ready() -> void:
	deck_label = %DeckName
	total_label = %ItemTotal
	final_list = %ItemList
	

func set_variables(deck_name: String, total: int, list: ItemList) -> void:
	if deck_name == "":
		deck_label.text = "Empty"
	else:
		deck_label.text = deck_name
		
	total_label.text = "with %d items" % total
	for i in range(list.get_item_count()):
		final_list.add_item(list.get_item_text(i))
	

func _on_back_button_down() -> void:
	BackgroundManager.hide_panel("Create Deck")
	

func _on_save_button_down() -> void:
	pass # Replace with function body.
	
