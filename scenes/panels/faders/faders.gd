extends PanelContainer

@export var send_address: String = "/fader/1/config"
@export var fader_count: int = 16:
	set(new_fader_count):
		_set_fader_count(new_fader_count)
		fader_count = new_fader_count

const FADER = preload("res://scenes/elements/fader/fader.tscn")

var osc_element: OSCElement

@onready var container: HBoxContainer = $HBoxContainer


func _ready() -> void:
	OSCGlobals.connected.connect(_setup)
	osc_element = OSCElement.new()
	add_child(osc_element)
	
	_set_fader_count(16)


## Set up the fader bank.
func _setup() -> void:
	osc_element.send_address = send_address + "/" + str(fader_count)
	osc_element.send_message([])


func _set_fader_count(count: int) -> void:
	if is_instance_valid(container):
		if container.get_child_count() > count:
			# Remove extra faders
			for i in container.child_count() - count:
				container.get_child(i + count).queue_free()
		
		elif container.get_child_count() < count:
			# Add missing faders
			for i in count - container.get_child_count():
				var fader: Fader = FADER.instantiate()
				fader.fader_index = container.get_child_count() + 1
				container.add_child(fader)
