@tool
extends OSCKey


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_mode = true
	toggled.connect(_on_input)
	
	if not Engine.is_editor_hint():
		# Clear the modifier when a key is pressed
		Globals.key_pressed.connect(_clear_modifier)


func _on_input(is_pressed: bool) -> void:
	target_user.send_message(command + "/" + key_string, [float(is_pressed)])


func _clear_modifier() -> void:
	button_pressed = false
