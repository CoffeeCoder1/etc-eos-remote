class_name Wheel extends Control

@export var wheel_index: int = 1:
	set(new_wheel_index):
		osc_element.send_address = send_address + "/" + str(new_wheel_index)
		osc_element.recieve_address = recieve_address + "/" + str(new_wheel_index)
		wheel_index = new_wheel_index
@export var send_address: String = "/active/switch"
@export var recieve_address: String = "/eos/out/active/wheel"
## Deletes the wheel if the feedback contains a type of 0 (null), which is sent when a wheel doesn't exist for the selected channel.
@export var delete_on_null_type: bool = true
## Should the wheel be relative or absolute?
@export var relative: bool = false:
	set(new_relative):
		if is_instance_valid(wheel_box):
			wheel_box.relative = new_relative
		relative = new_relative

@onready var max_button: OSCKey = $VBoxContainer/MaxButton
@onready var min_button: OSCKey = $VBoxContainer/MinButton
@onready var wheel_box: Control = $VBoxContainer/WheelBox

var osc_element: OSCElement
## Parameter name for display.
var parameter_name: String
## Parameter name, parsed to be OSC safe.
var osc_parameter_name: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	osc_element = OSCElement.new()
	add_child(osc_element)
	
	wheel_box.relative = relative
	osc_element.send_address = send_address + "/" + str(wheel_index)
	osc_element.feedback_mode = OSCElement.FeedbackMode.GLOBAL
	osc_element.recieve_address = recieve_address + "/" + str(wheel_index)
	osc_element.feedback_recieved.connect(_on_osc_feedback)


func _on_osc_feedback(value: Array):
	# Remove wheels that don't exist in the selected channel
	if value[1] == 0 && delete_on_null_type:
		queue_free()
	
	# Regex to remove value appended to property name
	var regex = RegEx.new()
	regex.compile(".+?(?=\\s*\\[\\d+])")
	
	parameter_name = regex.search(str(value[0])).get_string()
	osc_parameter_name = parameter_name.replace("/", "\\")
	
	$VBoxContainer/Label.text = parameter_name
	$VBoxContainer/Value.text = str(round(value[2]))
	$VBoxContainer/WheelBox/VSlider.set_value_no_signal(value[2])
	
	max_button.address_prefix = "/param/" + osc_parameter_name
	min_button.address_prefix = "/param/" + osc_parameter_name


func _on_wheel_box_dragged(distance: float) -> void:
	osc_element.send_message([distance])


func _on_wheel_box_released() -> void:
	osc_element.send_message([0])


func _on_wheel_box_value_changed(value: float) -> void:
	OSCGlobals.get_user().send_message("/param/" + osc_parameter_name + "/at", [value])
