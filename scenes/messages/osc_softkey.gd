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


func _process(delta: float) -> void:
	pass
	# TODO: Get this working again
	#var feedback = target_user.target_client.incoming_messages.get("/eos/out/softkey/" + key_string, [])
	#if feedback:
	#	key_label = str(feedback[0]).replace(" ", "\n")
