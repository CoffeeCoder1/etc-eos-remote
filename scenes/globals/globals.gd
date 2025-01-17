extends Node

signal key_pressed
## Emitted when the wheel mode is set.
signal wheel_modes_set(mode: Wheel.WheelMode)

## Switches the modes of all the wheels.
var wheel_mode: Wheel.WheelMode


func set_wheel_modes(new_mode: Wheel.WheelMode) -> void:
	wheel_mode = new_mode
	wheel_modes_set.emit(new_mode)


func _on_wheel_mode_set(new_wheel_mode: Wheel.WheelMode) -> void:
	wheel_mode = new_wheel_mode
