class_name OSCElement extends Node

@export var send_address: String
@export var recieve_address: String

signal feedback_recieved(value)

var target_user: OSCUser


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Find a better way to do this
	target_user = find_parent("Main").find_child("OSCUser")


func _process(delta: float) -> void:
	if recieve_address:
		var feedback = target_user.get_feedback(recieve_address)
		if feedback:
			feedback_recieved.emit(feedback[0])


func send_message(args: Array):
	target_user.send_message(send_address, args)
