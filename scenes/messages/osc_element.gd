class_name OSCElement extends Node

@export var send_address: String
@export var recieve_address: String
## What mode to use for recieving feedback.
@export var feedback_mode: FeedbackMode = FeedbackMode.USER

signal feedback_recieved(value: Array)

enum FeedbackMode {USER, FEEDBACK_USER, GLOBAL}


func _process(delta: float) -> void:
	if recieve_address:
		var feedback
		
		if feedback_mode == FeedbackMode.GLOBAL:
			feedback = OSCGlobals.get_user().get_global_feedback(recieve_address)
		elif feedback_mode == FeedbackMode.FEEDBACK_USER:
			feedback = OSCGlobals.get_user().get_user_feedback(recieve_address)
		elif feedback_mode == FeedbackMode.USER:
			feedback = OSCGlobals.get_user().get_feedback(recieve_address)
		
		if feedback:
			feedback_recieved.emit(feedback)


func send_message(args: Array):
	OSCGlobals.get_user().send_message(send_address, args)
