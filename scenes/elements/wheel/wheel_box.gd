extends Control

signal dragged(distance: float)


func _gui_input(event: InputEvent):
	if event is InputEventMouseMotion:
		if event.button_mask != 0:
			dragged.emit((get_global_rect().get_center().y - event.global_position.y) * 8 / size.y)
