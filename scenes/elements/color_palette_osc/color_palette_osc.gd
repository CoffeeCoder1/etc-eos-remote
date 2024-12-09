class_name ColorPaletteOSC extends Control

@export var send_address: String = "/color/xy"

var osc_element: OSCElement


func _ready() -> void:
	osc_element = OSCElement.new()
	add_child(osc_element)
	
	osc_element.send_address = send_address


func _on_color_changed(color: Vector2) -> void:
	osc_element.send_message([color.x, 1.0 - color.y])
