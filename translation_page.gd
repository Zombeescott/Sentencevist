extends Control

var native_sentence: RichTextLabel
var text_block: TextEdit
var skip_button: Button
var timer: Timer

var wrong_state: bool = false
var correct_state: bool = false

var current_native: String
var current_trans: String

var sent_one = Sentence.new("Sentence to translate", "Type this dipshit")
var sent_two = Sentence.new("This is the next sentence", "Type this again dipshit")

# Carries information for each sentence
class Sentence:
	var native: String
	var trans: String 
	
	func _init(n: String, t: String):
		native = n
		trans = t
	

func _ready() -> void:
	native_sentence = %Sentence
	text_block = %TextEdit
	skip_button = %"Skip Button"
	timer = %Timer
	
	current_native = sent_one.native
	current_trans = sent_one.trans
	

func _input(event): 
	if Input.is_action_just_pressed("enter"):
		if wrong_state:
			clean_display()
			prevent_change()
		elif check_answer():
			correct_response()
		else:
			incorrect_response()
	if event is InputEventKey and event.pressed:
		if wrong_state or correct_state:
			prevent_change()
	

# Checks if input was correct
func check_answer() -> bool: 
	if text_block.text == current_trans && !wrong_state:
		return true
	return false
	

# Shows user that they were wrong.
func incorrect_response() -> void:
	#text_block.theme.set_color("Thing", "Thing", Color.RED)
	wrong_state = true
	text_block.text = current_trans
	timer.start()
	

# Shows user that they were right.
func correct_response() -> void:
	#text_block.theme.set_color("Thing", "Thing", Color.GREEN)
	correct_state = true
	text_block.text = current_trans + "!!!"
	timer.start()
	

# Goes to next new sentence
func next_sentence(sentence: Sentence) -> void:
	current_native = sentence.native
	current_trans = sentence.trans
	clean_display()
	

# Fixes display if there is something going on
func clean_display() -> void:
	wrong_state = false
	correct_state = false
	#text_block.theme.clear_color("Thing", "Thing")
	native_sentence.text = current_native
	text_block.clear()
	

func prevent_change() -> void:
	# Wait until the end of the frame to check
	await get_tree().process_frame
	if wrong_state:
		text_block.text = current_trans
	elif correct_state:
		text_block.text = current_trans + "!!!"
	else:
		text_block.text = ""

# Skips the current sentence
func _on_skip_button_button_down() -> void:
	next_sentence(sent_two)
	

func _on_timer_timeout() -> void:
	if wrong_state:
		clean_display()
	if correct_state:
		next_sentence(sent_two)
	
