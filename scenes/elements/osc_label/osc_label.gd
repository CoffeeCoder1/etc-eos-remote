class_name OSCLabel extends Label

@export var feedback_mode: OSCElement.FeedbackMode = OSCElement.FeedbackMode.USER
@export var feedback_address: String:
	set(new_feedback_address):
		if is_instance_valid(osc_element):
			osc_element.recieve_address = new_feedback_address
			feedback_address = new_feedback_address

var osc_element: OSCElement


func _init() -> void:
	osc_element = OSCElement.new()
	add_child(osc_element, false, Node.INTERNAL_MODE_FRONT)


func _ready() -> void:
	osc_element.recieve_address = feedback_address
	osc_element.feedback_recieved.connect(_on_osc_feedback)
	osc_element.feedback_mode = feedback_mode


func _on_osc_feedback(value):
	text = str(value[0])
