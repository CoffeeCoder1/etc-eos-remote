class_name OSCSoftkey extends OSCKey

@export var softkey_index: int:
	set(new_index):
		key_string = str(softkey_index)
		softkey_index = new_index


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready() # Set up the button
	
	address_prefix = "/softkey"
	key_string = str(softkey_index)
	
	osc_element.recieve_address = "/eos/out/softkey/" + key_string
	osc_element.feedback_mode = OSCElement.FeedbackMode.GLOBAL
	osc_element.feedback_recieved.connect(_on_osc_feedback)


func _on_osc_feedback(value: Array):
	key_label = str(value[0]).replace(" ", "\n")
