extends Label

@export var target_user: OSCUser
@export var feedback_address: String


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var feedback = target_user.get_feedback(feedback_address)
	if feedback:
		text = feedback[0]
