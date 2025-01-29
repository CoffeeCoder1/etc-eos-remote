extends PanelContainer

@export var send_address: String = "/fader/1/config"

var osc_element: OSCElement


func _ready() -> void:
	osc_element = OSCElement.new()
	add_child(osc_element)
	
	osc_element.send_address = send_address
	osc_element.send_message([4])
