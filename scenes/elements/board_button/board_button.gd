class_name BoardButton extends PanelContainer

## Emitted when this board is selected.
signal board_selected
## Emitted when this board is selected for editing.
signal board_edit

@onready var button: Button = $MarginContainer/PanelContainer/Button


func _on_button_pressed() -> void:
	board_selected.emit()


func set_board(board: BoardSettings) -> void:
	button.text = board.get_board_name()


func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
			board_edit.emit()
