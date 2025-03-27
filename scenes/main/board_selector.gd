extends VBoxContainer

signal settings_button_pressed
signal new_board_button_pressed

@onready var board_list: BoardList = $BoardList


func _on_settings_button_pressed() -> void:
	settings_button_pressed.emit()


func _on_new_board_button_pressed() -> void:
	new_board_button_pressed.emit()


func add_board(board: BoardSettings) -> void:
	board_list.add_board(board)
