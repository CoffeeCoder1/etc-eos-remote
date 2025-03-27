extends Control

## Should the wheel be relative or absolute?
@export var relative: bool = false:
	set(new_relative):
		if is_instance_valid(v_slider):
			v_slider.editable = not new_relative
		if drag_active:
			released.emit()
		_absolute_held = false
		relative = new_relative

signal dragged(distance: float)
signal value_changed(value: float)
signal released

@onready var v_slider: VSlider = $VSlider

var drag_active: bool
## The current value.
var _value: float
## Is the slider currently being held in absolute mode?
var _absolute_held: bool


func _ready() -> void:
	v_slider.editable = not relative
	
	dragged.connect(_on_dragged)
	released.connect(_on_released)


func _gui_input(event: InputEvent):
	if relative:
		# Relative movement
		if event is InputEventMouseMotion:
			if event.button_mask != 0:
				dragged.emit((get_global_rect().get_center().y - event.global_position.y) / size.y)
		elif event is InputEventMouseButton:
			if not event.is_pressed():
				released.emit()
				
				if not relative:
					v_slider.set_value_no_signal(_value)
	
	if event is InputEventMouseButton:
		if not relative:
			_absolute_held = event.is_pressed()


func _on_v_slider_value_changed(value: float) -> void:
	if not relative:
		# Absolute movement
		value_changed.emit(value)


func _on_dragged(distance: float) -> void:
	drag_active = true


func _on_released() -> void:
	drag_active = false


## Sets the value feedback. Displayed immediately if in relative mode, waits until mouse release to
## be displayed in absolute mode.
func set_value_feedback(new_value: float) -> void:
	_value = new_value
	
	if relative or not _absolute_held:
		v_slider.set_value_no_signal(new_value)
