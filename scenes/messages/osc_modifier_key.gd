@tool
class_name OSCModifierKey extends OSCKey


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	clears_modifiers = false
	
	if not Engine.is_editor_hint():
		# Clear the modifier when a key is pressed
		Globals.key_pressed.connect(_clear_modifier)


func _clear_modifier() -> void:
	pass
	#button_pressed = false


func _input(event: InputEvent) -> void:
	# Button down and up signals are not emitted when the shortcut is pressed, so this catches those and calls _on_input.
	if key_shortcut:
		if key_shortcut.matches_event(event):
			if event.is_pressed():
				#button_pressed = true
				_on_input(true)
			else:
				#button_pressed = false
				_on_input(false)
