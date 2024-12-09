class_name ColorPalette extends Control

## Speed at which the cursor "chases" the mouse.
@export var relative_movement_speed: float = 0.4
@export var snap_drag_threshold: float = 0.005
@export var snap_drag_window: float = 0.25

signal color_changed(color: Vector2)

@onready var cursor: Sprite2D = $Cursor
@onready var relative_cursor: Sprite2D = $RelativeCursor

## Color coordinates [0-1]
var color: Vector2
## Used to check if the color has been changed.
var last_color: Vector2
## Position where a click and drag was initiated.
var start_position: Vector2
## Used to time when a click and drag has started.
var click_and_drag_timer: float
## Was the click and drag canceled (drag and snap)?
var snap_dragging: bool
var drag_started: bool


func _process(delta: float) -> void:
	if Input.is_action_pressed("palette_click"):
		var mouse_position := get_local_mouse_position()
		## Mouse position scaled to the size of the palette.
		var color_position := get_local_mouse_position() / size
		
		# Check for the start of a click and drag
		if Input.is_action_just_pressed("palette_click"):
			start_position = color_position
			relative_cursor.position = start_position * size
		
		# Find distance dragged
		var position_difference := (color_position - start_position)
		var drag_distance: float = abs(position_difference.x) + abs(position_difference.y)
		
		# Check if mouse click is inside the color palette
		if mouse_position.x > 0 and mouse_position.y > 0 and mouse_position.x < size.x and mouse_position.y < size.y:
			# Select drag mode
			if !drag_started:
				# If dragged far enough, use snap dragging
				if drag_distance > snap_drag_threshold:
					snap_dragging = true
					drag_started = true
					relative_cursor.hide()
				
				# If held long enough, use relative dragging
				if click_and_drag_timer > snap_drag_window:
					snap_dragging = false
					drag_started = true
					relative_cursor.show()
				
				click_and_drag_timer += delta
		
		if drag_started:
			# Snap dragging
			if snap_dragging:
				color = color_position
			# Relative dragging
			else:
				color += position_difference * relative_movement_speed * delta
		color = color.clamp(Vector2.ZERO, Vector2.ONE)
	else:
		# End drag and reset things
		relative_cursor.hide()
		click_and_drag_timer = 0
		drag_started = false
	cursor.position = color * size
	
	if color != last_color:
		color_changed.emit(color)
	last_color = color
