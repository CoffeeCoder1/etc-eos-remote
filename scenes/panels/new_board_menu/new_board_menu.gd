extends PanelContainer

## The port to show by default when displaying the menu.
@export var default_port: int = 3037
## The IP address to show by default when displaying the menu. Also shown as the placeholder text.
@export var default_ip_address: String = "127.0.0.1"

## Emitted when a board is created and should be added to the list.
signal create_board(board: BoardSettings)

@onready var ip_address_edit: LineEdit = %IPAddressEdit
@onready var port_edit: SpinBox = %PortEdit


func _ready() -> void:
	ip_address_edit.placeholder_text = default_ip_address


## Sets up the menu and displays it.
func _on_new_board_button_pressed() -> void:
	port_edit.set_value_no_signal(default_port)
	ip_address_edit.text = default_ip_address
	show()


func _on_cancel_button_pressed() -> void:
	hide()


func _on_create_button_pressed() -> void:
	var board := BoardSettings.new()
	board.set_ip_address(ip_address_edit.text)
	board.set_port(port_edit.value)
	create_board.emit(board)
	
	hide()
