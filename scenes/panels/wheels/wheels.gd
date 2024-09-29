extends PanelContainer

@export var recieve_address: String = "/eos/out/active/wheel"
@export var wheel_scene: PackedScene

var osc_element: OSCElement
var wheels: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	osc_element = OSCElement.new()
	add_child(osc_element)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for e in osc_element.target_user.target_client.incoming_messages:
		if str(e).begins_with(recieve_address):
			var feedback: Array = osc_element.target_user.get_global_feedback(e)
			if feedback[1] != 0 && !wheels.has(e):
				wheels.append(e)
				
				var wheel = wheel_scene.instantiate()
				%WheelContainer.add_child(wheel)
				wheel.wheel_index = int(str(e).get_slice(recieve_address + "/", 1))
			elif feedback[1] == 0 && wheels.has(e):
				wheels.erase(e)
