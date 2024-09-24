extends OSCMessage


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func send_command(command: String) -> void:
	target_client.send_message(osc_address, [command])
