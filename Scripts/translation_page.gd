extends Control

var native_sentence: RichTextLabel
var text_block: TextEdit
var skip_button: Button
var timer: Timer

var current_native: String
var current_trans: String
var wrong_state: bool = false
var correct_state: bool = false

var sent_one = Sentence.new("Sentence to translate", "Type this dipshit")
var sent_two = Sentence.new("This is the next sentence", "Type this again dipshit")

func _ready() -> void:
	native_sentence = %Sentence
	text_block = %TextEdit
	skip_button = %"Skip Button"
	timer = %Timer
	
	current_native = sent_one.native
	current_trans = sent_one.trans
	
#	Set the screen size TODO: Do this somewhere else later
	get_window().size = Vector2(2500, 1500)
	get_window().move_to_center()
	

func _input(event): 
	if Input.is_action_just_pressed("enter"):
		if wrong_state:
			clean_display()
		if wrong_state || correct_state:
			prevent_change()
		else:
			answer_feedback(check_answer())
	if event is InputEventKey and event.pressed:
		if wrong_state or correct_state:
			prevent_change()
	

# Checks if input was correct
func check_answer() -> bool: 
	if text_block.text == current_trans && (!wrong_state || !correct_state):
		return true
	return false
	

# Tells user if they were right or wrong.
func answer_feedback(status: bool) -> void:
	if status:
		correct_state = true
	else:
		wrong_state = true
	change_text_color()
	timer.start()
	

func change_text_color() -> void:
	text_block.text = current_trans
	if wrong_state:
		text_block.modulate = Color.CRIMSON
	elif correct_state:
		text_block.modulate = Color.LIME_GREEN
	

# Goes to next new sentence
func next_sentence(sentence: Sentence) -> void:
	current_native = sentence.native
	current_trans = sentence.trans
	clean_display()
	

# Fixes display if there is something going on
func clean_display() -> void:
	wrong_state = false
	correct_state = false
	native_sentence.text = current_native
	text_block.clear()
	text_block.modulate = Color.WHITE
	

func prevent_change() -> void:
	# Wait until the end of the frame to check
	await get_tree().process_frame
	if !wrong_state && !correct_state:
		text_block.text = ""
	else:
		change_text_color()
	

# Skips the current sentence
func _on_skip_button_button_down() -> void:
	next_sentence(sent_two)
	

func _on_timer_timeout() -> void:
	if wrong_state:
		clean_display()
	if correct_state:
		next_sentence(sent_two)
	
