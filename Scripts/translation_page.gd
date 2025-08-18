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
var sentence_dict: Dictionary
var sentence_keys: Array
var deck_order: int = 0
var deck_method: int = 0

var saved_words: Array
var retry_counter: int = RETRY_NUM

const RETRY_NUM = 3

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
		if wrong_state || correct_state:
			prevent_change()
		else:
			answer_feedback(check_answer())
	if event is InputEventKey and event.pressed:
		if wrong_state or correct_state:
			prevent_change()
	

func set_variables(settings: StudySettings) -> void:
	sentence_dict = Global.get_user_decks().get(settings.deck_name)
	sentence_keys = sentence_dict.keys()
	deck_method = settings.method
	deck_order = settings.order
	
	set_current_sentences()
	clean_display()
	

# Checks if input was correct
func check_answer() -> bool: 
	if text_block.text == current_trans && (!wrong_state || !correct_state):
		return true
	
	if deck_method == 1 and !saved_words.has(current_native):
		# Save for user to retry
		saved_words.append(current_native)
	
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
	

func set_current_sentences() -> bool:
	# TODO: clean up this place and its checks with sentence_keys == 0
	if sentence_keys.size() == 0 and saved_words.size() <= 0:
		current_native = "All done, no more sentences for this deck."
		current_trans = "Pick another deck to study"
		return false
	
	var curr: String
	
	if deck_method == 1 and saved_words.size() > 0:
		# If an error was made reuse faulty sentence
		if retry_counter > 0 and sentence_keys.size() > 0:
			# when counter hits zero, review words
			retry_counter -= 1
		else:
			curr = saved_words.pop_front()
			if saved_words.size() > 0:
				retry_counter = RETRY_NUM
			
	if retry_counter > 0 and sentence_keys.size() > 0: # Default method
		match deck_order:
			0: # In order
				curr = sentence_keys.pop_front()
			1: # Random
				curr = sentence_keys.pop_at(randi_range(0, sentence_keys.size() - 1))
	
	current_native = curr
	current_trans = sentence_dict.get(curr)
	return true
	

# Goes to next new sentence
func next_sentence() -> void:
	set_current_sentences()
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
	next_sentence()
	

func _on_timer_timeout() -> void:
	if wrong_state:
		clean_display()
	if correct_state:
		next_sentence()
	
