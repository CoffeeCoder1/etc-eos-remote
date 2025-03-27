class_name ModePanel extends PanelContainer

## The UI color when in live mode.
@export var live_color: Color = Color(0.149475, 0.149475, 0.149474, 1)
## The UI color when in blind mode.
@export var blind_color: Color = Color(0.0833569, 0.197115, 0.238439, 1)

var color_tween: Tween
var last_state: Array
var disconnected: bool = true


func _ready() -> void:
	OSCGlobals.disconnected.connect(_on_osc_disconnected)
	OSCGlobals.connected.connect(_on_osc_connected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var state: Array = OSCGlobals.get_client().get_incoming_messages().get("/eos/out/event/state", [1.0])
	
	if disconnected:
		state[0] = 1.0
	
	# Has the state changed?
	if state != last_state:
		if state[0] == 1.0:
			fade_bg_color(live_color)
		else:
			fade_bg_color(blind_color)
		last_state = state


## Sets the background color immediately
func _set_bg_color(bg_color: Color) -> void:
	var style_box: StyleBoxFlat = get_theme_stylebox("panel")
	style_box.set("bg_color", bg_color)
	add_theme_stylebox_override("panel", style_box)


## Fades the background color to the given color.
func fade_bg_color(bg_color: Color) -> void:
	# Remove old Tweens
	if color_tween:
		color_tween.kill()
	
	# Create a Tween for the color
	color_tween = get_tree().create_tween()
	
	# Check what state the board is in
	color_tween.tween_method(_set_bg_color, get_theme_stylebox("panel").get("bg_color"), bg_color, 0.5)


func _on_osc_disconnected() -> void:
	disconnected = true


func _on_osc_connected() -> void:
	disconnected = false
