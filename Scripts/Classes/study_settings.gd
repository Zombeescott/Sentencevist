class_name StudySettings
extends RefCounted

var deck_name: String
var order: int
var method: int

func _init(settings: Dictionary) -> void:
	deck_name = settings.get("deck_name", "")
	order = settings.get("order", 0)
	method = settings.get("method", 0)
	
