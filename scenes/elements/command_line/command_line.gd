class_name CommandLine extends TextEdit

@export var feedback_mode: OSCElement.FeedbackMode = OSCElement.FeedbackMode.FEEDBACK_USER
@export var feedback_address: String = "/cmd"

const COMMAND_LINE_SYNTAX_HIGHLIGHTER = preload("res://scenes/elements/command_line/command_line_syntax_highlighter.tres")

var osc_element: OSCElement


func _init() -> void:
	osc_element = OSCElement.new()
	add_child(osc_element, false, Node.INTERNAL_MODE_FRONT)
	osc_element.recieve_address = feedback_address
	osc_element.feedback_recieved.connect(_on_osc_feedback)
	osc_element.feedback_mode = feedback_mode


func _ready() -> void:
	syntax_highlighter = COMMAND_LINE_SYNTAX_HIGHLIGHTER
	
	text_changed.connect(_on_text_changed)


func _on_osc_feedback(value: Array):
	text = str(value[0]).replace("#", "♦")


func _on_text_changed() -> void:
	OSCGlobals.get_client().send_message("/eos/cmd", ["a"])
