class_name OSCElement extends Node

@export var send_address: String
@export var recieve_address: String
## What mode to use for recieving feedback.
@export var feedback_mode: FeedbackMode = FeedbackMode.USER

signal feedback_recieved(value: Array)

var target_user: OSCUser

enum FeedbackMode {USER, FEEDBACK_USER, GLOBAL}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Find a better way to do this
	target_user = find_parent("Main").find_child("OSCUser")


func _process(delta: float) -> void:
	if recieve_address:
		var feedback
		
		if feedback_mode == FeedbackMode.GLOBAL:
			feedback = target_user.get_global_feedback(recieve_address)
		elif feedback_mode == FeedbackMode.FEEDBACK_USER:
			feedback = target_user.get_user_feedback(recieve_address)
		elif feedback_mode == FeedbackMode.USER:
			feedback = target_user.get_feedback(recieve_address)
		
		if feedback:
			feedback_recieved.emit(feedback)


func send_message(args: Array):
	target_user.send_message(send_address, args)
