@tool
class_name OSCKey extends Button

@export var key_string: String:
	set(new_key_string):
		key_string = new_key_string
		_update_send_address()
@export var address_prefix: String = "/key":
	set(new_address_prefix):
		address_prefix = new_address_prefix
		_update_send_address()
@export_multiline var key_label: String:
	set(new_label):
		# Iterate through label lines
		for line in new_label.split("\n"):
			# Find a good font size, and, if it's smaller than the current one, set it as the font size override
			var font_size: int = 12 - ((line.length() - 5) * 1.05)
			if font_size <= get_theme_font_size("font_size"):
				add_theme_font_size_override("font_size", font_size)
			else:
				remove_theme_font_size_override("font_size")
		
		key_label = new_label
		text = new_label
## Should clicking this button clear any selected modifiers?
@export var clears_modifiers: bool = true

var osc_element: OSCElement


## Updates the OSCElement's send address. Not intended to be called outside of this class.
func _update_send_address() -> void:
	if osc_element:
		osc_element.send_address = address_prefix + "/" + key_string


## Sets up the button signals.
func _setup_button() -> void:
	button_down.connect(_on_input.bind(true))
	button_up.connect(_on_input.bind(false))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	osc_element = OSCElement.new()
	add_child(osc_element)
	
	_setup_button()
	_update_send_address()


func _on_input(is_pressed: bool) -> void:
	osc_element.send_message([float(is_pressed)])
	
	# Emit a signal signaling that a key has been pressed
	if is_pressed and clears_modifiers:
		Globals.emit_signal("key_pressed")
