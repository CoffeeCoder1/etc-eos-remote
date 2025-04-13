class_name Keypad extends PanelContainer

@onready var tab_container: TabContainer = %TabContainer
@onready var main_tab: HBoxContainer = %Keypad
@onready var targets_tab: HBoxContainer = %Targets
@onready var v_box_container: VBoxContainer = %VBoxContainer
@onready var v_box_container_2: VBoxContainer = %VBoxContainer2
@onready var v_box_container_3: VBoxContainer = %VBoxContainer3
@onready var v_box_container_4: VBoxContainer = %VBoxContainer4
@onready var v_box_container_5: VBoxContainer = %VBoxContainer5
@onready var wheel: Wheel = %Wheel


func _ready() -> void:
	item_rect_changed.connect(_on_rect_changed)


func _on_rect_changed() -> void:
	wheel.visible = size.x > 885
	tab_container.tabs_visible = size.x < 790
	
	if size.x < 790:
		v_box_container.reparent(targets_tab)
		v_box_container_5.reparent(targets_tab)
	else:
		v_box_container.reparent(main_tab)
		main_tab.move_child(v_box_container, 0)
		v_box_container.show()
		
		v_box_container_5.reparent(main_tab)
		main_tab.move_child(v_box_container_5, 4)
		v_box_container_5.show()
