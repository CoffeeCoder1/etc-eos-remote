class_name Wheel extends Control

@export var target_user: OSCUser
@export var wheel_index: int = 1
@export var send_address: String = "/wheel"
@export var recieve_address: String = "/eos/out/active/wheel"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var feedback = target_user.target_server.incoming_messages.get(recieve_address + "/" + str(wheel_index), [])
	if feedback:
		$VBoxContainer/Label.text = str(feedback[0])
		$VBoxContainer/Value.text = str(round(feedback[2]))
		$VBoxContainer/WheelBox/VSlider.value = feedback[2]


func _on_wheel_box_dragged(distance: float) -> void:
	target_user.send_message(send_address + "/" + str(wheel_index) + "/level", [distance])


# TODO: OSCKeys should be used for this instead of doing it manually (requires some changes to how OSCKeys are given a target user)
func _on_min_button_button_down() -> void:
	target_user.send_message("/at/min", [1])


func _on_min_button_button_up() -> void:
	target_user.send_message("/at/min", [0])


func _on_max_button_button_down() -> void:
	target_user.send_message("/at/max", [1])


func _on_max_button_button_up() -> void:
	target_user.send_message("/at/max", [0])
