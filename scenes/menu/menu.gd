class_name Menu extends Control

## Emitted when the menu is closed.
signal menu_closed


## Closes the menu.
func close() -> void:
	menu_closed.emit()
