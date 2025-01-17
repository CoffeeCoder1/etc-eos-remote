extends Node

signal key_pressed
signal set_wheel_modes(relative: bool)

## Enables relative control for wheels.
var wheel_mode: bool


func _on_wheel_mode_set(relative: bool) -> void:
	wheel_mode = relative
