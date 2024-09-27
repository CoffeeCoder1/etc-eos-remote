@tool
extends OSCKey


func _setup_button():
	toggle_mode = true
	toggled.connect(_on_input)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	clears_modifiers = false
	
	if not Engine.is_editor_hint():
		# Clear the modifier when a key is pressed
		Globals.key_pressed.connect(_clear_modifier)


func _clear_modifier() -> void:
	button_pressed = false
