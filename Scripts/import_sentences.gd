extends Control

var name_box: LineEdit
var text_edit: TextEdit
var item_list: ItemList
var total_counter: RichTextLabel
var create_screen: PackedScene

var sentence_data: String
var sentences: Array[Sentence] = []

func _ready() -> void:
	name_box = %DeckName
	text_edit = %TextInput
	item_list = %CompleteSentences
	total_counter = %Total
	create_screen = preload("res://Scenes/save_deck.tscn")
	

func parse_sentence_data(text: String) -> void:
	if sentences:
		sentences.clear()
	if item_list:
		item_list.clear()
	
	var lines = text.split("\n")
	for i in range(0, lines.size(), 2):
		if i + 1 < lines.size():  # Make sure next line exis
			if lines[i] != "" and lines[i+1] != "":
				var temp = Sentence.new(lines[i], lines[i+1])
				sentences.append(temp)
				item_list.add_item(temp.to_string())
	
	update_total()
	

func convert_data() -> void:
	sentence_data = text_edit.text
	parse_sentence_data(sentence_data)
	

# Update the amount of sentences there are.
func update_total() -> void:
	total_counter.text = "%s items" % sentences.size()
	

func _on_convert_button_down() -> void:
	convert_data()
	

# Remove clicked item
func _on_complete_sentences_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	item_list.remove_item(index)
	sentences.pop_at(index)
	update_total()
	

func _on_next_button_down() -> void:
	convert_data()
	var create = create_screen.instantiate()
	BackgroundManager.add_panel("Create Deck", create, 1)
	create.set_variables(name_box.text, sentences.size(), item_list)
	
