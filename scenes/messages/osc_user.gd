class_name OSCUser extends Node

@export var user_number: int = 1
@export var osc_send_prefix: String
@export var osc_recieve_prefix: String
@export var target_client: OSCClient
@export var target_server: OSCServer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func send_message(osc_message: String, args: Array) -> void:
	target_client.send_message(osc_send_prefix + "/" + str(user_number) + osc_message, args)


func get_feedback(osc_address: String) -> Array:
	return target_server.incoming_messages.get(osc_recieve_prefix + "/" + str(user_number) + osc_address, [])
