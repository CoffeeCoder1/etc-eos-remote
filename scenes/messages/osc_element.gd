class_name OSCElement extends Node

@export var send_address: String
@export var recieve_address: String
## Is the feedback address local to the user or global?
@export var global_feedback: bool = false

signal feedback_recieved(value: Array)

var target_user: OSCUser


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Find a better way to do this
	target_user = find_parent("Main").find_child("OSCUser")


func _process(delta: float) -> void:
	if recieve_address:
		var feedback
		
		if global_feedback:
			feedback = target_user.get_global_feedback(recieve_address)
		else:
			feedback = target_user.get_feedback(recieve_address)
		
		if feedback:
			feedback_recieved.emit(feedback)


func send_message(args: Array):
	target_user.send_message(send_address, args)
