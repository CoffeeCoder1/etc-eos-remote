extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str($"../../../../../../../../../OSCClientTCP".port)


func _on_text_submitted(new_text: String) -> void:
	$"../../../../../../../../../OSCClientTCP".port = int(new_text)
