extends CanvasLayer

var panels: Dictionary = {}

var background_scene: PackedScene
var sidebar_scene: PackedScene
var current_background: Node
var current_sidebar: Node

func _ready() -> void:
	if get_tree().current_scene.name == "Background":
		return
	
	#background_scene = preload("res://Scenes/background.tscn")
	#current_background = show_scene(background_scene, current_background, -1000)
	

func show_scene(packed: PackedScene, scene: Node, layer: int = 0) -> Node:
	if scene:
		scene.queue_free()
	
	scene = packed.instantiate()
	get_tree().current_scene.add_child(scene)
	scene.z_index = layer
	return(scene)
	

func instantiate_panel(name: String, panel_scene: PackedScene, layer: int = 0) -> void:
	# Close existing panel with same name
	if name in panels:
		panels[name].queue_free()
	
	# Create new panel
	var panel = panel_scene.instantiate()
	add_panel(name, panel, layer)
	

func add_panel(name: String, panel: Node, layer: int = 0) -> void:
	get_tree().current_scene.add_child(panel)
	#self.add_child(panel)
	panel.z_index = layer
	
	panels[name] = panel
	

func hide_panel(name: String) -> void:
	if name in panels:
		panels[name].queue_free()
		panels.erase(name)
	
