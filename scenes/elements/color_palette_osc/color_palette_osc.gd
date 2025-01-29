class_name ColorPaletteOSC extends Control

@export var send_address: String = "/color/hs"
@export var feedback_mode: OSCElement.FeedbackMode = OSCElement.FeedbackMode.GLOBAL
@export var feedback_address: String = "/eos/out/color/hs"

var osc_element: OSCElement

@onready var color_palette: ColorPalette = %ColorPalette


func _ready() -> void:
	osc_element = OSCElement.new()
	add_child(osc_element)
	
	osc_element.send_address = send_address
	osc_element.feedback_mode = feedback_mode
	osc_element.recieve_address = feedback_address
	osc_element.feedback_recieved.connect(_on_osc_feedback)
	
	var color_test: Color = Color(0.212, 0.377, 0.743)
	var test_color_xy = ColorConversions.color_to_xy(color_test)
	var test_color = ColorConversions.xy_to_color(test_color_xy)
	print(color_test)
	print(test_color_xy)
	print(test_color)


func _on_color_changed(color: Color) -> void:
	osc_element.send_message([color.h * 360.0, color.s * 100.0])


func _on_osc_feedback(value: Array) -> void:
	if len(value) == 2:
		if value[0] > 0 and value[1] > 0:
			var color = Color.from_hsv(value[0] / 360.0, value[1] / 100.0, 1.0)
			$ColorRect.color = color
			color_palette.set_color(color)
	#osc_element.send_message([color.x, color.y])
