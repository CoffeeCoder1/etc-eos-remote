extends Control

signal dragged(distance: float)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _gui_input(event: InputEvent):
	if event is InputEventMouseMotion:
		if event.button_mask != 0:
			dragged.emit((get_global_rect().get_center().y - event.global_position.y) * 8 / size.y)
