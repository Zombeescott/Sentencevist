extends Control

var native_sentence: RichTextLabel
var text_block: TextEdit
var correct_label: RichTextLabel
var prev_ans_label: RichTextLabel
var skip_button: Button
var timer: Timer

var current_native: String
var current_trans: String
var wrong_state: bool = false
var correct_state: bool = false

var sent_one = Sentence.new("Sentence to translate.", "Type this dipshit.")
var sent_two = Sentence.new("This is the next sentence.", "Type this again dipshit.")
var sentence_dict: Dictionary
var sentence_keys: Array
var deck_order: int = 0
var deck_method: int = 0
var use_prev_ans: bool = true

var saved_words: Array
var retry_counter: int = RETRY_NUM

const RETRY_NUM: int = 3

func _ready() -> void:
	native_sentence = %Sentence
	text_block = %TextEdit
	correct_label = %CorrectLabel
	prev_ans_label = %PrevAnsLabel
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
	use_prev_ans = settings.prev_ans
	
	set_current_sentences()
	clean_display()
	

# Checks if input was correct
func check_answer() -> bool: 
	if text_block.text == current_trans && (!wrong_state || !correct_state):
		return true
	
	if deck_method == 1 and !saved_words.has(current_native):
		# Save for user to retry
		saved_words.append(current_native)
	if use_prev_ans:
		prev_ans_label.text = text_block.text
	
	return false
	

# Tells user if they were right or wrong.
func answer_feedback(status: bool) -> void:
	if status:
		correct_state = true
	else:
		wrong_state = true
	
	correct_label.text = change_text_color(text_block.text, current_trans)
	correct_label.get_parent().visible = true
	text_block.text = ""
	timer.start()
	

func change_text_color(user_input: String, correct_text: String) -> String:
	var user_words = user_input.split(" ")
	var correct_words = correct_text.split(" ")
	var result = ""
	
	var max_words = max(user_words.size(), correct_words.size())
	
	for word_index in range(max_words):
		if word_index > 0:
			result += " "  # Add space between words
			
		var user_word = user_words[word_index] if word_index < user_words.size() else ""
		var correct_word = correct_words[word_index] if word_index < correct_words.size() else ""
		
		# Compare letters within this word
		result += compare_word_letters(user_word, correct_word)
	
	return result
	

func compare_word_letters(user_word: String, correct_word: String) -> String:
	var result = ""
	var max_length = max(user_word.length(), correct_word.length())
	
	for i in range(max_length):
		var user_letter = user_word[i] if i < user_word.length() else ""
		var correct_letter = correct_word[i] if i < correct_word.length() else ""
		
		if user_letter == "" and correct_letter != "":
			# Missing letter
			result += "%s" % correct_letter
		elif user_letter != "" and correct_letter == "":
			# Extra letter
			result += "[color=red]%s[/color]" % correct_letter
		elif user_letter == correct_letter:
			# Correct letter
			result += "[color=lime_green]%s[/color]" % correct_letter
		else:
			# Wrong letter
			result += "[color=red]%s[/color]" % correct_letter
	
	return result
	

func set_current_sentences() -> bool:
	var more_sents = sentence_keys.size() > 0
	
	if !more_sents and saved_words.size() <= 0:
		current_native = "All done, no more sentences for this deck."
		current_trans = "Pick another deck to study"
		return false
	
	var curr: String = ""
	
	if deck_method == 1 and saved_words.size() > 0:
		# If an error was made, reuse faulty sentence
		if retry_counter > 0 and more_sents:
			# when counter hits zero, review words
			retry_counter -= 1
		else:
			curr = saved_words.pop_front()
			if saved_words.size() > 0:
				retry_counter = RETRY_NUM
			
	if retry_counter > 0 and more_sents: # Default method
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
	
	if use_prev_ans:
		prev_ans_label.text = ""
	

# Fixes display if there is something going on
func clean_display() -> void:
	wrong_state = false
	correct_state = false
	native_sentence.text = current_native
	correct_label.text = ""
	correct_label.get_parent().visible = false
	

func prevent_change() -> void:
	# Wait until the end of the frame to check
	await get_tree().process_frame
	text_block.text = ""
	

# Skips the current sentence
func _on_skip_button_button_down() -> void:
	next_sentence()
	

func _on_timer_timeout() -> void:
	if wrong_state:
		clean_display()
	if correct_state:
		next_sentence()
	
