extends Node

## Emitted when the app connects to a server.
signal connected
## Emitted when the app disconnects from a server.
signal disconnected

@onready var osc_client_tcp: OSCClientTCP = $OSCClientTCP
@onready var osc_user: OSCUser = $OSCUser


func _ready() -> void:
	# Set up signals.
	osc_client_tcp.connected.connect(connected.emit)
	osc_client_tcp.connected.connect(_setup)
	osc_client_tcp.disconnected.connect(disconnected.emit)
	
	AppSettings.settings.user_id_set.connect(_on_settings_user_id_set)
	_on_settings_user_id_set(AppSettings.settings.get_user_id())


func get_client() -> OSCClientTCP:
	return osc_client_tcp


func get_user() -> OSCUser:
	return osc_user


func _on_settings_user_id_set(new_user_id: int) -> void:
	osc_user.user_number = new_user_id


## Sends setup messages to the EOS console. This sets up connection details like feedback.
func _setup() -> void:
	osc_client_tcp.send_message("/eos/subscribe", [1])
