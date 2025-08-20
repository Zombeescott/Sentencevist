class_name StudySettings
extends RefCounted

var deck_name: String
var order: int
var method: int
var prev_ans: bool

func _init() -> void:
	deck_name = ""
	order = 0
	method = 0
	prev_ans = true
	

func with_deck_name(name: String) -> StudySettings:
	deck_name = name
	return self
	

func with_order(order_type: int) -> StudySettings:
	order = order_type
	return self
	

func with_method(method_type: int) -> StudySettings:
	method = method_type
	return self
	

func with_prev_ans(ans: bool) -> StudySettings:
	prev_ans = ans
	return self
	
