extends Label

@export var target_user: OSCUser
@export var feedback_address: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var feedback = target_user.get_feedback(feedback_address)
	if feedback:
		text = feedback[0]
