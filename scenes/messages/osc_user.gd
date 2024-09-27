class_name OSCUser extends Node

@export var user_number: int = 1
@export var osc_send_prefix: String
@export var osc_recieve_prefix: String
@export var target_client: OSCClientTCP


func _ready() -> void:
	target_client.send_message("/eos/reset", [])
	target_client.send_message("/eos/subscribe", [1.0])


func send_message(osc_message: String, args: Array) -> void:
	target_client.send_message(osc_send_prefix + "/" + str(user_number) + osc_message, args)
	print(osc_send_prefix + "/" + str(user_number) + osc_message, args)


func get_feedback(osc_address: String) -> Array:
	return target_client.incoming_messages.get(osc_recieve_prefix + "/" + str(user_number) + osc_address, [])
