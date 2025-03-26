class_name StatusLabel extends Label

@export var connected_text: String = "Connected"
@export var disconnected_text: String = "Disconnected"


func _ready() -> void:
	OSCGlobals.get_client().connected.connect(_on_connected)
	OSCGlobals.get_client().disconnected.connect(_on_disconnected)


func _on_connected() -> void:
	text = connected_text


func _on_disconnected() -> void:
	text = disconnected_text
