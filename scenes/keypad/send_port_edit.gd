extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str($"../../../../../../../../../OSCClient".port)


func _on_text_submitted(new_text: String) -> void:
	$"../../../../../../../../../OSCClient".port = int(new_text)
