extends TextEdit

@export var feedback_mode: OSCElement.FeedbackMode = OSCElement.FeedbackMode.USER
@export var feedback_address: String

var osc_element: OSCElement


func _ready() -> void:
	osc_element = OSCElement.new()
	add_child(osc_element)
	
	osc_element.recieve_address = feedback_address
	osc_element.feedback_recieved.connect(_on_osc_feedback)
	osc_element.feedback_mode = feedback_mode


func _on_osc_feedback(value: Array):
	text = str(value[0]).replace("#", "♦")
