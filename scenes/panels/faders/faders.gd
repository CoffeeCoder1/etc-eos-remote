extends PanelContainer

@export var send_address: String = "/fader/1/config"

var osc_element: OSCElement


func _ready() -> void:
	OSCGlobals.connected.connect(_setup)
	osc_element = OSCElement.new()
	add_child(osc_element)


## Set up the fader bank.
func _setup() -> void:
	osc_element.send_address = send_address + "/4"
	osc_element.send_message([])
