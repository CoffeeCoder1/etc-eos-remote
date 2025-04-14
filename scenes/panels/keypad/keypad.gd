class_name Keypad extends PanelContainer

@onready var tab_bar: TabBar = %TabBar
@onready var key_panels: Control = %KeyPanels
@onready var v_box_container: VBoxContainer = %VBoxContainer
@onready var v_box_container_2: VBoxContainer = %VBoxContainer2
@onready var v_box_container_3: VBoxContainer = %VBoxContainer3
@onready var v_box_container_4: VBoxContainer = %VBoxContainer4
@onready var v_box_container_5: VBoxContainer = %VBoxContainer5
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
		v_box_container.set_meta("tab", Tabs.TARGET)
		v_box_container_5.set_meta("tab", Tabs.TARGET)
	else:
		v_box_container.set_meta("tab", Tabs.MAIN)
		v_box_container_5.set_meta("tab", Tabs.MAIN)
	
	queue_redraw()


func _draw() -> void:
	for panel: Control in key_panels.get_children():
		if panel.get_meta("tab", Tabs.MAIN) == tab_bar.current_tab:
			panel.show()
		else:
			panel.hide()
