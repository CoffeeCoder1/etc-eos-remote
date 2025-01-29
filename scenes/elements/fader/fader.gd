class_name Fader extends Control

@export var fader_index: int = 1:
	set(new_fader_index):
		if is_instance_valid(osc_element):
			osc_element.send_address = send_address + "/" + str(new_fader_index)
			osc_element.recieve_address = recieve_address + "/" + str(new_fader_index) + "/name"
		fader_index = new_fader_index
@export var send_address: String = "/chan"
@export var recieve_address: String = "/eos/out/chan"

var osc_element: OSCElement
## Parameter name for display.
var parameter_name: String
## Parameter name, parsed to be OSC safe.
var osc_parameter_name: String


## Sets the mode of the wheel.
enum WheelMode {
	## Proportional control over values.
	RELATIVE,
	## Absolute control over values.
	ABSOLUTE,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	osc_element = OSCElement.new()
	add_child(osc_element)
	
	osc_element.send_address = send_address + "/" + str(fader_index)
	osc_element.feedback_mode = OSCElement.FeedbackMode.GLOBAL
	osc_element.recieve_address = recieve_address + "/" + str(fader_index) + "/name"
	osc_element.feedback_recieved.connect(_on_osc_feedback)


func _on_osc_feedback(value: Array):
	$VBoxContainer/Label.text = value


func _on_slider_value_changed(value: float) -> void:
	osc_element.send_message([value])
