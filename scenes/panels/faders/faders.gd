extends PanelContainer

@export var send_address: String = "/fader/1/config"
@export var fader_count: int = 16

var osc_element: OSCElement


func _ready() -> void:
	OSCGlobals.connected.connect(_setup)
	osc_element = OSCElement.new()
	add_child(osc_element)


## Set up the fader bank.
func _setup() -> void:
	osc_element.send_address = send_address + "/" + str(fader_count)
	osc_element.send_message([])
