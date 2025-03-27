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
		label.text = new_label
		key_label = new_label
## Should clicking this button clear any selected modifiers?
@export var clears_modifiers: bool = true
## Should this button latch? This is effectively the same as default toggle buttons, but more tailored
## for modifier keys.
@export var latching: bool = false
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
var label: AutoSizeLabel
## The current mode to draw the button in.
var draw_mode: DrawMode = DrawMode.DRAW_NORMAL
## Is the button currently pressed?
var pressed: bool
## Is the button forced to be on (ie. by a keyboard key)? This prevents the latch state from being
## cleared by other buttons.
var force_on: bool
## Is the mouse hovering over the button?
var hovering: bool


## Updates the OSCElement's send address. Not intended to be called outside of this class.
func _update_send_address() -> void:
	if osc_element:
		osc_element.send_address = address_prefix + "/" + key_string


func _init() -> void:
	if not Engine.is_editor_hint():
		osc_element = OSCElement.new()
		add_child(osc_element, false, Node.INTERNAL_MODE_FRONT)
	
	panel_container = PanelContainer.new()
	panel_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(panel_container, false, Node.INTERNAL_MODE_FRONT)
	
	label = AutoSizeLabel.new()
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.size_flags_vertical = Control.SIZE_FILL
	label.size_flags_horizontal = Control.SIZE_FILL
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	panel_container.add_child(label, false, Node.INTERNAL_MODE_FRONT)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		Globals.key_pressed.connect(_clear_latch)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	label.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	_update_send_address()


func _get_minimum_size() -> Vector2:
	return panel_container.size


func _input(event: InputEvent) -> void:
	# Shortcut key
	if key_shortcut:
		# Allow TextEdit nodes to grab focus
		if key_shortcut.matches_event(event) and not (get_viewport().gui_get_focus_owner() is TextEdit):
			force_on = event.is_pressed()
			_on_input(event.is_pressed())


func _gui_input(event: InputEvent) -> void:
	# Mouse click
	if event is InputEventMouseButton:
		if latching:
			# Toggle latching button
			if event.is_pressed():
				_on_input(!pressed)
		else:
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
	pressed = is_pressed
	
	if is_pressed:
		draw_mode = DrawMode.DRAW_PRESSED
	else:
		draw_mode = DrawMode.DRAW_NORMAL
	
	queue_redraw()
	
	osc_element.send_message([float(is_pressed)])
	
	# Emit a signal signaling that a key has been pressed
	if is_pressed and clears_modifiers:
		Globals.emit_signal("key_pressed")


## Unpresses the button if latched on.
func _clear_latch() -> void:
	if latching and pressed and not force_on:
		_on_input(false)
