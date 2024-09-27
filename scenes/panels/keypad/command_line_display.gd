extends Label

@export var feedback_address: String

var osc_element: OSCElement


func _ready() -> void:
	osc_element = OSCElement.new()
	add_child(osc_element)
	osc_element.recieve_address = feedback_address
	osc_element.feedback_recieved.connect(_on_osc_feedback)


func _on_osc_feedback(value):
	text = value[0]
