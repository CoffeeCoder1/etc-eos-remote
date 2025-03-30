@tool
class_name OSCKey extends Key

@export var key_string: String:
	set(new_key_string):
		key_string = new_key_string
		_update_send_address()
@export var address_prefix: String = "/key":
	set(new_address_prefix):
		address_prefix = new_address_prefix
		_update_send_address()

var osc_element: OSCElement
var panel_container: PanelContainer
var label: AutoSizeLabel
## Is the button forced to be on (ie. by a keyboard key)? This prevents the latch state from being
## cleared by other buttons.
var force_on: bool


## Updates the OSCElement's send address. Not intended to be called outside of this class.
func _update_send_address() -> void:
	if osc_element:
		osc_element.send_address = address_prefix + "/" + key_string


func _init() -> void:
	if not Engine.is_editor_hint():
		osc_element = OSCElement.new()
		add_child(osc_element, false, Node.INTERNAL_MODE_FRONT)
	
	super._init()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_down.connect(_on_button_state_changed.bind(true))
	button_up.connect(_on_button_state_changed.bind(false))
	
	super._ready()
	
	_update_send_address()


func _on_button_state_changed(pressed: bool) -> void:
	osc_element.send_message([float(pressed)])
