extends Control

signal dragged(distance: float)
signal released


func _gui_input(event: InputEvent):
	if event is InputEventMouseMotion:
		if event.button_mask != 0:
			dragged.emit((get_global_rect().get_center().y - event.global_position.y) / size.y)
	elif event is InputEventMouseButton:
		if not event.is_pressed():
			released.emit()
