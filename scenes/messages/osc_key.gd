@tool
class_name OSCKey extends Control

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
		label.text = new_label
## Should clicking this button clear any selected modifiers?
@export var clears_modifiers: bool = true
## Shortcut used for the key.
@export var key_shortcut: Shortcut

## Modes the button can be drawn in.
enum DrawMode {
	## Disabled.
	DRAW_DISABLED,
	## Normal. Replaced by DRAW_HOVER when hovering.
	DRAW_NORMAL,
	## Hovering (not pressed).
	DRAW_HOVER,
	## Pressed.
	DRAW_PRESSED,
}

var osc_element: OSCElement
var panel_container: PanelContainer
var label: Label
## The current mode to draw the button in.
var draw_mode: DrawMode = DrawMode.DRAW_NORMAL
## Is the mouse hovering over the button?
var hovering: bool


## Updates the OSCElement's send address. Not intended to be called outside of this class.
func _update_send_address() -> void:
	if osc_element:
		osc_element.send_address = address_prefix + "/" + key_string


func _init() -> void:
	if not Engine.is_editor_hint():
		osc_element = OSCElement.new()
		add_child(osc_element)
	
	panel_container = PanelContainer.new()
	panel_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(panel_container)
	
	label = Label.new()
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel_container.add_child(label)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	label.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	_update_send_address()


func _get_minimum_size() -> Vector2:
	return panel_container.size


func _input(event: InputEvent) -> void:
	# Shortcut key
	if key_shortcut:
		if key_shortcut.matches_event(event):
			_on_input(event.is_pressed())


func _gui_input(event: InputEvent) -> void:
	# Mouse click
	if event is InputEventMouseButton:
		_on_input(event.is_pressed())


## Gets the current draw mode.
## Substitutes DRAW_HOVER in place of DRAW_NORMAL when hovering.
func get_draw_mode() -> DrawMode:
	match draw_mode:
		DrawMode.DRAW_NORMAL:
			if hovering:
				return DrawMode.DRAW_HOVER
			else:
				return DrawMode.DRAW_NORMAL
		_:
			return draw_mode


func _draw() -> void:
	match get_draw_mode():
		DrawMode.DRAW_DISABLED:
			panel_container.add_theme_stylebox_override("panel", get_theme_stylebox("disabled", "Button"))
		DrawMode.DRAW_NORMAL:
			panel_container.add_theme_stylebox_override("panel", get_theme_stylebox("normal", "Button"))
		DrawMode.DRAW_HOVER:
			panel_container.add_theme_stylebox_override("panel", get_theme_stylebox("hover", "Button"))
		DrawMode.DRAW_PRESSED:
			panel_container.add_theme_stylebox_override("panel", get_theme_stylebox("pressed", "Button"))


func _on_mouse_entered() -> void:
	hovering = true
	queue_redraw()


func _on_mouse_exited() -> void:
	hovering = false
	queue_redraw()


## Handles an input and updates the button accordingly.
func _on_input(is_pressed: bool) -> void:
	if is_pressed:
		draw_mode = DrawMode.DRAW_PRESSED
	else:
		draw_mode = DrawMode.DRAW_NORMAL
	
	queue_redraw()
	
	osc_element.send_message([float(is_pressed)])
	
	# Emit a signal signaling that a key has been pressed
	if is_pressed and clears_modifiers:
		Globals.emit_signal("key_pressed")
