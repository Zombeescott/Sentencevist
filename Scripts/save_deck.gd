extends Control

var deck_label: Label
var total_label: Label
var final_list: ItemList
var final_dict: Dictionary

func _ready() -> void:
	deck_label = %DeckName
	total_label = %ItemTotal
	final_list = %ItemList
	

func set_variables(deck_name: String, total: int, sentences: Dictionary) -> void:
	if deck_name == "":
		deck_label.text = "Empty"
	else:
		deck_label.text = deck_name
		
	total_label.text = "with %d items" % total
	Global.fill_list_sentences(final_list, sentences)
	
	final_dict = sentences
	

func hide_panel() -> void:
	BackgroundManager.hide_panel("Create Deck")
	

func _on_back_button_down() -> void:
	hide_panel()
	

func _on_save_button_down() -> void:
	if SaveManager.save_user_deck(deck_label.text, final_dict):
		# TODO: tell user that it was successful
		hide_panel()
		
		# Shortcut for files
		var user_path = ProjectSettings.globalize_path("user://saves/")
		OS.shell_open(user_path)
	else:
		# TODO: tell user that something went wrong
		pass
	
