class_name MenuContainer extends PanelContainer

@onready var menu_container: CenterContainer = $CenterContainer

var _menu: Menu


## Shows the given menu.
func show_menu(menu: PackedScene) -> Menu:
	if is_instance_valid(_menu):
		_menu.queue_free()
	
	_menu = menu.instantiate() as Menu
	_menu.menu_closed.connect(_on_menu_closed)
	menu_container.add_child(_menu)
	
	show()
	
	return _menu


func _on_menu_closed() -> void:
	hide()
	_menu.queue_free()
