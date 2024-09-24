class_name OSCUser extends OSCMessage

@export var user_number: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func send_message(osc_message: String, args: Array) -> void:
	target_client.send_message(osc_address + "/" + str(user_number) + osc_message, args)
