extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$OSCCommand.send_command("Chan 1 Full Enter")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
