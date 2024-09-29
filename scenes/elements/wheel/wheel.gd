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

var osc_element: OSCElement


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	osc_element = OSCElement.new()
	add_child(osc_element)
	
	osc_element.send_address = send_address + "/" + str(wheel_index)
	osc_element.global_feedback = true
	osc_element.recieve_address = recieve_address + "/" + str(wheel_index)
	osc_element.feedback_recieved.connect(_on_osc_feedback)


func _on_osc_feedback(value: Array):
	# Remove wheels that don't exist in the selected channel
	if value[1] == 0 && delete_on_null_type:
		queue_free()
	
	# Regex to remove value appended to property name
	var regex = RegEx.new()
	regex.compile(".+?(?= \\[\\d+])")
	
	$VBoxContainer/Label.text = regex.search(str(value[0])).get_string()
	$VBoxContainer/Value.text = str(round(value[2]))
	$VBoxContainer/WheelBox/VSlider.value = value[2]


func _on_wheel_box_dragged(distance: float) -> void:
	osc_element.send_message([distance])


func _on_wheel_box_released() -> void:
	osc_element.send_message([0])
