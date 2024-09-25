class_name OSCKey extends Button

@export var key_string: String
@export var target_user: OSCUser
@export var command: String = "/key"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_down.connect(_on_input.bind(true))
	button_up.connect(_on_input.bind(false))


func _process(delta: float) -> void:
	# Iterate through label lines
	for line in text.split("\n"):
		# Find a good font size, and, if it's smaller than the current one, set it as the font size override
		var font_size: int = 12 - ((line.length() - 6) * 1.1)
		if font_size <= get_theme_font_size("font_size"):
			add_theme_font_size_override("font_size", font_size)
		else:
			remove_theme_font_size_override("font_size")


func _on_input(is_pressed: bool) -> void:
	target_user.send_message(command + "/" + key_string, [float(is_pressed)])
	
	# Emit a signal signaling that a key has been pressed
	if is_pressed:
		Globals.emit_signal("key_pressed")
