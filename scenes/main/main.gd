class_name Main extends Control

@onready var board_selector_container: VBoxContainer = %BoardSelectorContainer
@onready var interface_container: VBoxContainer = %InterfaceContainer


func _ready() -> void:
	OSCGlobals.connected.connect(_on_osc_connected)
	OSCGlobals.disconnected.connect(_on_osc_disconnected)


func _on_osc_connected() -> void:
	board_selector_container.hide()
	interface_container.show()


func _on_osc_disconnected() -> void:
	board_selector_container.show()
	interface_container.hide()
