class_name Main extends Control

const SETTINGS_MENU = preload("res://scenes/menu/settings_menu/settings_menu.tscn")
const BOARD_MENU = preload("res://scenes/menu/board_menu/board_menu.tscn")
const NEW_BOARD_MENU = preload("res://scenes/menu/new_board_menu/new_board_menu.tscn")

@onready var board_selector_container: Control = %BoardSelectorContainer
@onready var interface_container: Control = %InterfaceContainer
@onready var menu_container: MenuContainer = %MenuContainer
@onready var connecting_message: Control = $ConnectingMessage


func _ready() -> void:
	OSCGlobals.connected.connect(_on_osc_connected)
	OSCGlobals.disconnected.connect(_on_osc_disconnected)
	OSCGlobals.board_connecting.connect(_on_board_connecting)
	OSCGlobals.board_disconnected.connect(_on_board_disconnected)


func _on_osc_connected() -> void:
	board_selector_container.hide()
	interface_container.show()
	connecting_message.hide()


func _on_osc_disconnected() -> void:
	interface_container.hide()
	if OSCGlobals.is_board_connected():
		connecting_message.show()


func _on_board_disconnected() -> void:
	connecting_message.hide()
	board_selector_container.show()


func _on_settings_button_pressed() -> void:
	menu_container.show_menu(SETTINGS_MENU)


func _on_board_menu_button_pressed() -> void:
	var menu := menu_container.show_menu(BOARD_MENU) as BoardMenu
	menu.settings_pressed.connect(_on_settings_button_pressed)


func _on_new_board_button_pressed() -> void:
	var menu := menu_container.show_menu(NEW_BOARD_MENU) as NewBoardMenu
	menu.create_board.connect(board_selector_container.add_board)


func _on_disconnect_button_pressed() -> void:
	OSCGlobals.disconnect_board()


func _on_board_connecting() -> void:
	connecting_message.show()
	board_selector_container.hide()
	interface_container.hide()
