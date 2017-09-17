tool
extends EditorPlugin

# Add our custom node type

func _enter_tree():
    # Initialization of the plugin goes here
	add_custom_type("ScrollingBackground", "Node", preload("scrolling_background.gd"), preload("icon.png"))

# Remove the custom node type

func _exit_tree():
    # Clean-up of the plugin goes here
    remove_custom_type("ScrollingBackground")