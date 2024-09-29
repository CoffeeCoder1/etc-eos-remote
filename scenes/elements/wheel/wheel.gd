class_name Wheel extends Control

@export var wheel_index: int = 1:
	set(new_wheel_index):
		osc_element.send_address = send_address + "/" + str(new_wheel_index)
		osc_element.recieve_address = recieve_address + "/" + str(new_wheel_index)
		wheel_index = new_wheel_index
@export var send_address: String = "/active/switch"
@export var recieve_address: String = "/eos/out/active/wheel"

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
	if value[1] == 0:
		queue_free()
	$VBoxContainer/Label.text = str(value[0])
	$VBoxContainer/Value.text = str(round(value[2]))
	$VBoxContainer/WheelBox/VSlider.value = value[2]


func _on_wheel_box_dragged(distance: float) -> void:
	osc_element.send_message([distance])


func _on_wheel_box_released() -> void:
	osc_element.send_message([0])
