extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = $"../../../../../../../../../OSCClient".ip_address


func _on_text_submitted(new_text: String) -> void:
	$"../../../../../../../../../OSCClient".ip_address = new_text
