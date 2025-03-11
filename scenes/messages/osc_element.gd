class_name OSCElement extends Node

@export var send_address: String
@export var recieve_address: String
## What mode to use for recieving feedback.
@export var feedback_mode: FeedbackMode = FeedbackMode.USER

## Emitted when the feedback value from the server changes.
signal feedback_recieved(value: Array)

## The last feedback value recieved from the server. Used to check if feedback has actually changed
## before emitting a signal.
var last_feedback: Array

## The mode to use for feedback addresses.
enum FeedbackMode {
	## Base addresses from the current user.
	USER,
	## Base addresses from the current user as reported in the console feedback (needed because user
	## -1 doesn't always get feedback).
	FEEDBACK_USER,
	## Base addresses from the root address.
	GLOBAL,
}


func _process(delta: float) -> void:
	if recieve_address:
		var feedback
		
		if feedback_mode == FeedbackMode.GLOBAL:
			feedback = OSCGlobals.get_user().get_global_feedback(recieve_address)
		elif feedback_mode == FeedbackMode.FEEDBACK_USER:
			feedback = OSCGlobals.get_user().get_user_feedback(recieve_address)
		elif feedback_mode == FeedbackMode.USER:
			feedback = OSCGlobals.get_user().get_feedback(recieve_address)
		
		if feedback != last_feedback:
			feedback_recieved.emit(feedback)
			last_feedback = feedback


func send_message(args: Array):
	OSCGlobals.get_user().send_message(send_address, args)
