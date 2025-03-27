class_name BoardList extends PanelContainer

signal new_board_button_pressed

const BOARD_BUTTON = preload("res://scenes/elements/board_button/board_button.tscn")

@onready var board_container: VBoxContainer = %BoardContainer


func _ready() -> void:
	for board in AppSettings.settings.get_board_list():
		_add_board(board)


func add_board(board: BoardSettings) -> void:
	AppSettings.settings.add_board(board)
	_add_board(board)


func _add_board(board: BoardSettings) -> void:
	var button := BOARD_BUTTON.instantiate()
	board_container.add_child(button)
	
	button.board_selected.connect(_board_button_pressed.bind(board))
	button.set_board(board)


func _board_button_pressed(board: BoardSettings) -> void:
	OSCGlobals.get_client().connect_socket(board.get_ip_address(), board.get_port())


func _on_new_board_button_pressed() -> void:
	new_board_button_pressed.emit()
