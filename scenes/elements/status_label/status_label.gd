class_name StatusLabel extends Label

@export var connected_text: String = "Connected"
@export var disconnected_text: String = "Disconnected"


func _ready() -> void:
	if OSCGlobals.get_client().is_connected:
		_on_connected()
	else:
		_on_disconnected()
	
	OSCGlobals.connected.connect(_on_connected)
	OSCGlobals.disconnected.connect(_on_disconnected)


func _on_connected() -> void:
	text = connected_text


func _on_disconnected() -> void:
	text = disconnected_text
