class_name OSCGroup extends Container

@export var target_user: OSCUser
@export var address: String = "/key"

signal settings_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_settings_button_pressed() -> void:
	settings_button_pressed.emit()
