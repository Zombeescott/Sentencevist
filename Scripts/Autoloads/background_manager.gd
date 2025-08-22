extends CanvasLayer

var background: Node
var sidebar: Node

var panels: Dictionary = {}


func _ready() -> void:
	background = get_tree().current_scene
	sidebar = background.find_child("Sidebar")
	panels["start_panel"] = background.find_child("Deck Selection")
	

# Makes specific scene appear on a given layer
func show_scene(packed: PackedScene, scene: Node, layer: int = 0) -> Node:
	if scene:
		scene.queue_free()
	
	scene = packed.instantiate()
	get_tree().current_scene.add_child(scene)
	scene.z_index = layer
	return(scene)
	

# Instantiates and adds panel to current scene
func instantiate_panel(name: String, panel_scene: PackedScene, layer: int = 0) -> void:
	# Create new panel
	var panel = panel_scene.instantiate()
	add_panel(name, panel, layer)
	

# Adds existing panel to current scene
func add_panel(name: String, panel: Node, layer: int = 0) -> void:
	# Close existing panel with same name
	if name in panels:
		panels[name].queue_free()
	panel.z_index = layer
	panels[name] = panel
	get_tree().current_scene.add_child(panel)
	

# Deletes given panel from current scene.
func hide_panel(name: String) -> void:
	if name in panels:
		panels[name].queue_free()
		panels.erase(name)
	

# Changes screen
func change_screen(scene: PackedScene) -> void:
	clear_panels()
	instantiate_panel(scene.resource_name, scene)
	

# Clears all panels except for the specified one
func clear_panels(key: String = "") -> void:
	for each in panels.keys():
		if each != key:
			hide_panel(each)
	

## Side panel functions
func manual_change_screen(screen: String) -> void:
	sidebar.manual_screen_change(screen)
