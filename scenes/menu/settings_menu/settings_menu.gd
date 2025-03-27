class_name SettingsMenu extends Menu

@onready var user_edit: SpinBox = %UserEdit
@onready var wheel_mode_selector: OptionButton = %WheelModeSelector


func _ready() -> void:
	user_edit.set_value_no_signal(AppSettings.settings.get_user_id())
	match AppSettings.settings.get_wheel_mode():
		Wheel.WheelMode.RELATIVE:
			wheel_mode_selector.select(0)
		Wheel.WheelMode.ABSOLUTE:
			wheel_mode_selector.select(1)


func _on_close_button_pressed() -> void:
	close()


func _on_user_selected(user_number: int) -> void:
	AppSettings.settings.set_user_id(user_number)


func _on_wheel_mode_selector_item_selected(index: int) -> void:
	if (index == 0):
		AppSettings.settings.set_wheel_mode(Wheel.WheelMode.RELATIVE)
	elif (index == 1):
		AppSettings.settings.set_wheel_mode(Wheel.WheelMode.ABSOLUTE)
