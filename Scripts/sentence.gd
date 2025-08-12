class_name Sentence
extends RefCounted

# Carries information for each sentence
var native: String
var trans: String 

func _init(n: String, t: String):
	assert(n != "", "Native text cannot be empty")
	assert(t != "", "Translation cannot be empty")
	native = n
	trans = t
