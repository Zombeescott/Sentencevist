extends Control

var back_button: Button
var start_button: Button
var order_option: OptionButton
var method_option: OptionButton
var sent_list: ItemList
var translation_screen: PackedScene

var selected_deck: String

func _ready() -> void:
	back_button = %Back
	start_button = %Start
	order_option = %OrderOption
	method_option = %MethodOption
	sent_list = %Sentences
	translation_screen = preload("res://Scenes/translation_page.tscn")
	

func set_variables(deck_name: String) -> void:
	selected_deck = deck_name
	
	# TODO: have a variable to account for example decks
	var deck_sentences = Global.get_user_decks().get(deck_name)
	Global.fill_list_sentences(sent_list, deck_sentences)
	

func _on_back_button_down() -> void:
	BackgroundManager.hide_panel("Deck Settings")
	

func _on_start_button_down() -> void:
	BackgroundManager.manual_change_screen("translation")
	var screen = translation_screen.instantiate()
	BackgroundManager.add_panel("Translation", screen)
	
	var settings: Dictionary = {
		"deck_name": selected_deck,
		"order": order_option.get_selected_id(),
		"method": method_option.get_selected_id()
	}
	var setee = StudySettings.new(settings)
	screen.set_variables(setee)
	
	# Clear everything but new screen
	BackgroundManager.clear_panels("Translation")
	
