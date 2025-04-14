extends Control

signal settings_button_pressed
## Emitted when the new board button is pressed.
signal new_board_button_pressed
## Emitted when a board button is pressed.
signal board_button_pressed(board: BoardSettings)

@onready var board_list: BoardList = $BoardList


func _on_settings_button_pressed() -> void:
	settings_button_pressed.emit()


func _on_new_board_button_pressed() -> void:
	new_board_button_pressed.emit()


func add_board(board: BoardSettings) -> void:
	board_list.add_board(board)


func _on_board_list_board_button_pressed(board: BoardSettings) -> void:
	board_button_pressed.emit(board)
