class_name BoardList extends PanelContainer

const BOARD_BUTTON = preload("res://scenes/elements/board_button/board_button.tscn")

@onready var board_container: VBoxContainer = $ScrollContainer/BoardContainer


func _ready() -> void:
	for board in AppSettings.settings.get_board_list():
		var button := BOARD_BUTTON.instantiate()
		board_container.add_child(button)
		
		button.board_selected.connect(_board_button_pressed.bind(board))
		button.set_board(board)


func _board_button_pressed(board: BoardSettings) -> void:
	OSCGlobals.get_client().connect_socket(board.get_ip_address(), board.get_port())
