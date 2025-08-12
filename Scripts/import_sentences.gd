extends Control

var text_edit: TextEdit
var sentence_data: String
var sentences: Array[Sentence] = []

func _ready() -> void:
	text_edit = %TextEdit
	

func parse_sentence_data(text: String) -> void:
	var lines = text.split("\n")
	for i in range(0, lines.size(), 2):
		if i + 1 < lines.size():  # Make sure next line exis
			if lines[i] != "" and lines[i+1] != "":
				sentences.append(Sentence.new(lines[i], lines[i+1]))
		print(sentences[i].native + ", " + sentences[i].trans)
	

func _on_submit_button_down() -> void:
	sentence_data = text_edit.text
	parse_sentence_data(sentence_data)
	
