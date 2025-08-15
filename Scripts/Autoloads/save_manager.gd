extends Node

const USER_DECKS_PATH = "user://saves/"
const SYSTEM_EXAMPLES_PATH = "res://data/examples/"
const USER_PROGRESS_PATH = "user://user_progress.json"

func _ready():
	# Create user save directory if it doesn't exist
	if not DirAccess.dir_exists_absolute(USER_DECKS_PATH):
		DirAccess.open("user://").make_dir_recursive("saves")
	

## System/Example Files (Read-only)
func load_example_deck() -> Array:
	return load_decks(SYSTEM_EXAMPLES_PATH)
	

func load_user_deck() -> Array:
	return load_decks(USER_DECKS_PATH)
	

func load_decks(path: String) -> Array:
	var examples = []
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.ends_with(".json"):
				var example_data = load_json_file(path + file_name)
				if example_data:
					example_data["is_system_file"] = true
					example_data["filename"] = file_name
					examples.append(example_data)
			file_name = dir.get_next()
	
	return examples
	

func save_user_deck(deck_name: String, sentences: Dictionary) -> bool:
	var path = USER_DECKS_PATH + deck_name + ".json"
	return save_json_file(path, sentences)
	

## User Files
func save_user_data(save_data: Dictionary) -> bool:
	return save_json_file(USER_PROGRESS_PATH, save_data)
	

func load_user_data() -> Dictionary:
	return load_json_file(USER_PROGRESS_PATH)
	

## Utility Functions
func save_json_file(file_path: String, data: Dictionary) -> bool:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		print("Failed to open file for writing: ", file_path)
		return false
	
	var json_string = JSON.stringify(data)
	file.store_string(json_string)
	file.close()
	return true
	

func load_json_file(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		print("File not found: ", file_path)
		return {}
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		print("Error parsing JSON: ", file_path)
		return {}
	
	return json.data
	
