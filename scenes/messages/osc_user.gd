class_name OSCUser extends Node

@export var user_number: int = 1:
	set(new_user_number):
		if target_client && user_number != new_user_number:
			target_client.send_message("/eos/user", [new_user_number])
		user_number = new_user_number
@export var osc_send_prefix: String
@export var osc_recieve_prefix: String
@export var target_client: OSCClientTCP

## User that the console has sent out as feedback.
var feedback_user = 1


func _process(delta: float) -> void:
	# TODO: Fix this properly so user -1 is always the user selected on the console.
	if user_number == -1:
		feedback_user = 1
	else:
		var user_feedback = get_global_feedback("/eos/out/user")
		if user_feedback:
			feedback_user = user_feedback[0]


func send_message(osc_message: String, args: Array) -> void:
	target_client.send_message(osc_send_prefix + "/" + str(user_number) + osc_message, args)


func get_feedback(osc_address: String) -> Array:
	return target_client.incoming_messages.get(osc_recieve_prefix + "/" + str(user_number) + osc_address, [])


## Returns feedback for the osc address prefixed with the user that the console has sent out with the address `/eos/out/user`.
func get_user_feedback(osc_address: String) -> Array:
	return target_client.incoming_messages.get(osc_recieve_prefix + "/" + str(feedback_user) + osc_address, [])


func get_global_feedback(osc_address: String) -> Array:
	return target_client.incoming_messages.get(osc_address, [])
