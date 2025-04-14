class_name Keypad extends PanelContainer

@onready var tab_bar: TabBar = %TabBar
@onready var key_panels: Control = %KeyPanels
@onready var panel_1: AspectRatioContainer = %Panel1
@onready var panel_2: AspectRatioContainer = %Panel2
@onready var panel_3: AspectRatioContainer = %Panel3
@onready var panel_4: AspectRatioContainer = %Panel4
@onready var panel_5: AspectRatioContainer = %Panel5
@onready var wheel: Wheel = %Wheel

enum Tabs {
	MAIN = 0,
	TARGET= 1,
}


func _ready() -> void:
	item_rect_changed.connect(_on_rect_changed)
	tab_bar.tab_changed.connect(queue_redraw.unbind(1))


func _on_rect_changed() -> void:
	wheel.visible = size.aspect() > 1.47
	tab_bar.visible = size.aspect() < 1.313
	
	if size.aspect() < 1.313:
		panel_1.set_meta("tab", Tabs.TARGET)
		panel_5.set_meta("tab", Tabs.TARGET)
	else:
		panel_1.set_meta("tab", Tabs.MAIN)
		panel_5.set_meta("tab", Tabs.MAIN)
		tab_bar.current_tab = Tabs.MAIN
	
	queue_redraw()


func _draw() -> void:
	for panel: Control in key_panels.get_children():
		if panel.get_meta("tab", Tabs.MAIN) == tab_bar.current_tab:
			panel.show()
		else:
			panel.hide()
