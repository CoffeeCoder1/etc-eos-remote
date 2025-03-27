class_name BoardButton extends PanelContainer

## Emitted when this board is selected.
signal board_selected
## Emitted when this board is selected for editing.
signal board_edit

@onready var key: Key = $MarginContainer/Key


func _on_button_pressed() -> void:
	board_selected.emit()


func set_board(board: BoardSettings) -> void:
	key.text = board.get_board_name()


func _on_key_held() -> void:
	board_edit.emit()
