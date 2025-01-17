extends PanelContainer

@onready var ip_address_edit: LineEdit = %IPAddressEdit
@onready var port_edit: SpinBox = %PortEdit
@onready var user_edit: SpinBox = %UserEdit
@onready var wheel_mode_selector: OptionButton = %WheelModeSelector


func _on_settings_button_pressed() -> void:
	ip_address_edit.text = AppSettings.get_ip_address()
	port_edit.value = AppSettings.get_port()
	user_edit.value = AppSettings.get_user_id()
	match AppSettings.get_wheel_mode():
		Wheel.WheelMode.RELATIVE:
			wheel_mode_selector.selected = 0
		Wheel.WheelMode.ABSOLUTE:
			wheel_mode_selector.selected = 1
	show()


func _on_close_button_pressed() -> void:
	AppSettings.set_port(port_edit.value)
	hide()


func _on_user_selected(user_number: int) -> void:
	AppSettings.set_user_id(user_number)


func _on_ip_address_submitted(ip_address: String) -> void:
	AppSettings.set_ip_address(ip_address)


func _on_wheel_mode_selector_item_selected(index: int) -> void:
	if (index == 0):
		AppSettings.set_wheel_mode(Wheel.WheelMode.RELATIVE)
	elif (index == 1):
		AppSettings.set_wheel_mode(Wheel.WheelMode.ABSOLUTE)
