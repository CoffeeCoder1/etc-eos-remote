class_name OSCUser extends Node

@export var user_number: int = 1
@export var osc_send_prefix: String
@export var osc_recieve_prefix: String
@export var target_client: OSCClient
@export var target_server: OSCServer


func _ready() -> void:
	target_client.send_message("/eos/reset", [])


func send_message(osc_message: String, args: Array) -> void:
	target_client.send_message(osc_send_prefix + "/" + str(user_number) + osc_message, args)


func get_feedback(osc_address: String) -> Array:
	return target_server.incoming_messages.get(osc_recieve_prefix + "/" + str(user_number) + osc_address, [])
