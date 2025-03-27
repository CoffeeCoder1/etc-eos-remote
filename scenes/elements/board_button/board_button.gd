class_name BoardButton extends PanelContainer

## Emitted when this board is selected.
signal board_selected

@onready var button: Button = $MarginContainer/PanelContainer/Button


func _on_button_pressed() -> void:
	board_selected.emit()


func set_board(board: BoardSettings) -> void:
	button.text = board.get_ip_address()
