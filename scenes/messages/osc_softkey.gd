class_name OSCSoftkey extends OSCKey

@export var softkey_index: int:
	set(new_index):
		key_string = str(softkey_index)
		softkey_index = new_index


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready() # Set up the button signals
	command = "/softkey"
	key_string = str(softkey_index)


func _process(delta: float) -> void:
	super._process(delta) # Adjust font scale
	var feedback = target_user.target_server.incoming_messages.get("/eos/out/softkey/" + key_string, [])
	if feedback:
		text = str(feedback[0]).replace(" ", "\n")
