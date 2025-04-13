@tool
class_name Key extends Control

## The label text displayed on the key.
@export_multiline var text: String:
	set(new_label):
		_label.text = new_label
		text = new_label
## Should clicking this button clear any selected modifiers?
@export var clears_modifiers: bool = true
## Should this button latch? This is effectively the same as default toggle buttons, but more tailored
## for modifier keys.
@export var latching: bool = false
## Enables the hold action.
@export var hold_enabled: bool = false
## The time to wait before triggering a hold action.
@export var hold_time: float = 1.5
## Shortcut used for the key.
@export var key_shortcut: Shortcut
## Determines when the key is considered pressed.
@export var action_mode: Button.ActionMode = Button.ActionMode.ACTION_MODE_BUTTON_RELEASE

## Emitted when the key is pressed.
signal button_down
## Emitted when the key is released.
signal button_up
## Emitted when the key is pressed. Behavior is dependent on the [member action_mode].
signal pressed
## Emitted when the key is held. This requires the [member hold_enabled] option to be enabled.
signal held

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

## The root container used by the key.
var _panel_container: PanelContainer
## The label shown on the key.
var _label: AutoSizeLabel
## The current mode to draw the button in.
var draw_mode: DrawMode = DrawMode.DRAW_NORMAL
## Is the button currently pressed?
var _pressed: bool
## Is the button forced to be on (ie. by a keyboard key)? This prevents the latch state from being
## cleared by other buttons.
var _force_on: bool
## Is the mouse hovering over the button?
var hovering: bool
## Incremented to time the hold action.
var _hold_timer: float = 0.0:
	set(_new_hold_timer):
		if is_instance_valid(_hold_progress_bar):
			_hold_progress_bar.value = _new_hold_timer / hold_time
		
		_hold_timer = _new_hold_timer
## ProgressBar used to show the hold timer progress.
var _hold_progress_bar: ProgressBar


func _init() -> void:
	_panel_container = PanelContainer.new()
	_panel_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_panel_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_panel_container, false, Node.INTERNAL_MODE_FRONT)
	
	_label = AutoSizeLabel.new()
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label.size_flags_vertical = Control.SIZE_FILL
	_label.size_flags_horizontal = Control.SIZE_FILL
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_panel_container.add_child(_label, false, Node.INTERNAL_MODE_FRONT)
	
	_hold_progress_bar = ProgressBar.new()
	_hold_progress_bar.max_value = 1.0
	_hold_progress_bar.show_percentage = false
	_hold_progress_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_hold_progress_bar.size_flags_vertical = Control.SIZE_FILL
	_hold_progress_bar.size_flags_horizontal = Control.SIZE_FILL
	_hold_progress_bar.add_theme_stylebox_override("background", StyleBoxEmpty.new())
	_panel_container.add_child(_hold_progress_bar, false, Node.INTERNAL_MODE_FRONT)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		Globals.key_pressed.connect(_clear_latch)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	_label.add_theme_stylebox_override("normal", StyleBoxEmpty.new())


func _process(delta: float) -> void:
	# Wait for the hold timer
	if _pressed and hold_enabled:
		_hold_timer += delta
		
		if _hold_timer >= hold_time:
			held.emit()
			_pressed = false
			_hold_timer = 0.0


func _input(event: InputEvent) -> void:
	# Shortcut key
	if key_shortcut:
		# Allow TextEdit nodes to grab focus
		if key_shortcut.matches_event(event) and not (get_viewport().gui_get_focus_owner() is TextEdit):
			_force_on = event.is_pressed()
			_on_input(event.is_pressed())


func _gui_input(event: InputEvent) -> void:
	# Mouse click
	if event is InputEventMouseButton:
		if latching:
			# Toggle latching button
			if event.is_pressed():
				_on_input(!_pressed)
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
			_panel_container.add_theme_stylebox_override("panel", get_theme_stylebox("disabled", "Button"))
		DrawMode.DRAW_NORMAL:
			_panel_container.add_theme_stylebox_override("panel", get_theme_stylebox("normal", "Button"))
		DrawMode.DRAW_HOVER:
			_panel_container.add_theme_stylebox_override("panel", get_theme_stylebox("hover", "Button"))
		DrawMode.DRAW_PRESSED:
			_panel_container.add_theme_stylebox_override("panel", get_theme_stylebox("pressed", "Button"))


func _on_mouse_entered() -> void:
	hovering = true
	queue_redraw()


func _on_mouse_exited() -> void:
	hovering = false
	queue_redraw()


## Handles an input and updates the button accordingly.
func _on_input(is_pressed: bool) -> void:
	if _pressed != is_pressed:
		if is_pressed:
			button_down.emit()
			
			if action_mode == Button.ActionMode.ACTION_MODE_BUTTON_PRESS:
				pressed.emit()
		else:
			button_up.emit()
			
			if action_mode == Button.ActionMode.ACTION_MODE_BUTTON_RELEASE:
				pressed.emit()
	
	_pressed = is_pressed
	
	if is_pressed:
		draw_mode = DrawMode.DRAW_PRESSED
	else:
		draw_mode = DrawMode.DRAW_NORMAL
		_hold_timer = 0.0
	
	queue_redraw()
	
	# Emit a signal signaling that a key has been pressed
	if is_pressed and clears_modifiers:
		Globals.emit_signal("key_pressed")


## Unpresses the button if latched on.
func _clear_latch() -> void:
	if latching and _pressed and not _force_on:
		_on_input(false)
