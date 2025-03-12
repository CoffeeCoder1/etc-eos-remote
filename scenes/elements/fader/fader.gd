class_name Fader extends Control

## The fader bank this is a part of.
@export var fader_bank: int = 1:
	set(new_fader_bank):
		_set_fader_index(new_fader_bank, fader_index)
		fader_bank = new_fader_bank
## The index of the fader in the bank
@export var fader_index: int = 1:
	set(new_fader_index):
		_set_fader_index(fader_bank, new_fader_index)
		fader_index = new_fader_index

const ADDRESS: String = "/eos/fader"
const FEEDBACK_ADDRESS: String = "/eos/out/fader"

## OSC element used to send and recieve the value of the fader.
var value_element: OSCElement
## OSC element used to send and recieve the label of the fader.
var label_element: OSCElement
## Parameter name for display.
var parameter_name: String
## Parameter name, parsed to be OSC safe.
var osc_parameter_name: String

@onready var label: Label = $VBoxContainer/Label
@onready var slider: VSlider = $VBoxContainer/Slider


## Updates the OSC addresses with a new index.
func _set_fader_index(bank: int, index: int) -> void:
	if is_instance_valid(value_element):
		value_element.send_address = ADDRESS + "/" + str(fader_bank) + "/" + str(index)
		value_element.recieve_address = ADDRESS + "/" + str(fader_bank) + "/" + str(index)
	if is_instance_valid(label_element):
		label_element.recieve_address = FEEDBACK_ADDRESS + "/" + str(fader_bank) + "/" + str(index) + "/name"


func _init() -> void:
	value_element = OSCElement.new()
	value_element.feedback_mode = OSCElement.FeedbackMode.GLOBAL
	value_element.feedback_recieved.connect(_on_value_feedback)
	add_child(value_element, false, Node.INTERNAL_MODE_FRONT)
	
	label_element = OSCElement.new()
	label_element.feedback_mode = OSCElement.FeedbackMode.GLOBAL
	label_element.feedback_recieved.connect(_on_label_feedback)
	add_child(label_element, false, Node.INTERNAL_MODE_FRONT)


func _ready() -> void:
	# Set up the feedback addresses
	_set_fader_index(fader_bank, fader_index)


func _on_value_feedback(value: Array):
	slider.set_value_no_signal(value.get(0))


func _on_label_feedback(value: Array):
	label.text = value.get(0)


func _on_slider_value_changed(value: float) -> void:
	value_element.send_message([value])
