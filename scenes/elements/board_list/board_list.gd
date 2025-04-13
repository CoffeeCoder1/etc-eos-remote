class_name BoardList extends PanelContainer

## Emitted when the new board button is pressed.
signal new_board_button_pressed
## Emitted when a board button is pressed.
signal board_button_pressed(board: BoardSettings)

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
	button.board_selected.connect(board_button_pressed.emit.bind(board))
	button.board_edit.connect(_board_edit_button_pressed.bind(board, button))
	button.set_board(board)


func _board_button_pressed(board: BoardSettings) -> void:
	OSCGlobals.connect_board(board)


func _board_edit_button_pressed(board: BoardSettings, board_button: BoardButton) -> void:
	AppSettings.settings.remove_board(board)
	board_button.queue_free()


func _on_new_board_button_pressed() -> void:
	new_board_button_pressed.emit()
