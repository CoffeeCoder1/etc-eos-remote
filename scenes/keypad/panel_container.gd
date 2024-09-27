extends PanelContainer

@export var live_color: Color
@export var blind_color: Color
@export var target_user: OSCUser

var color_tween: Tween
var last_state: Array


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var state: Array = target_user.target_client.incoming_messages.get("/eos/out/event/state", [])
	# Has the state changed?
	if state != last_state:
		# Remove old Tweens
		if color_tween:
			color_tween.kill()
		
		# Create a Tween for the color
		color_tween = get_tree().create_tween()
		
		# Check what state the board is in
		if state[0] == 1.0:
			color_tween.tween_method(_set_bg_color, get_theme_stylebox("panel").get("bg_color"), live_color, 0.5)
		else:
			color_tween.tween_method(_set_bg_color, get_theme_stylebox("panel").get("bg_color"), blind_color, 0.5)
		
		last_state = state


func _set_bg_color(bg_color: Color) -> void:
	var style_box: StyleBoxFlat = get_theme_stylebox("panel")
	style_box.set("bg_color", bg_color)
	add_theme_stylebox_override("panel", style_box)
