class_name OSCKey extends Button

@export var key_string: String
@export var target_user: OSCUser
@export var command: String = "/key"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_down.connect(_on_input.bind(true))
	button_up.connect(_on_input.bind(false))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input(is_pressed: bool) -> void:
	target_user.send_message(command + "/" + key_string, [float(is_pressed)])
