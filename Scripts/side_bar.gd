extends Control

var list: ItemList
var minimize_button: CheckBox
var scene_list: Array[PackedScene]

func _ready() -> void:
	list = %ItemList
	minimize_button = %Minimize
	
	scene_list.append(preload("res://Scenes/translation_page.tscn"))
	scene_list.append(preload("res://Scenes/import_sentences.tscn"))
	scene_list.append(preload("res://Scenes/deck_selection.tscn"))

func _on_minimize_toggled(toggled_on: bool) -> void:
	if toggled_on:
		list.custom_minimum_size = Vector2(0,0)
	else: 
		list.custom_minimum_size = Vector2(125,0)
	

func _on_item_list_item_selected(index: int) -> void:
	BackgroundManager.clear_panels()
	var scene: PackedScene = scene_list[index]
	BackgroundManager.instantiate_panel(scene.resource_name, scene)
