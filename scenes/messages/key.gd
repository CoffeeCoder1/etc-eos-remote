extends OSCMessage


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func press_key(key: String) -> void:
	target_client.send_message(osc_address + "/" + key, [1.0])


func release_key(key: String) -> void:
	target_client.send_message(osc_address + "/" + key, [0.0])
