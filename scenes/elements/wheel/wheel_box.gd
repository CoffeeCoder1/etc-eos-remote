extends Control

## Should the wheel be relative or absolute?
@export var relative: bool = false:
	set(new_relative):
		if is_instance_valid(v_slider):
			v_slider.editable = not new_relative
		if drag_active:
			released.emit()
		relative = new_relative

signal dragged(distance: float)
signal value_changed(value: float)
signal released

@onready var v_slider: VSlider = $VSlider

var drag_active: bool


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


func _on_v_slider_value_changed(value: float) -> void:
	if not relative:
		# Absolute movement
		value_changed.emit(value)


func _on_dragged(distance: float) -> void:
	drag_active = true


func _on_released() -> void:
	drag_active = false
