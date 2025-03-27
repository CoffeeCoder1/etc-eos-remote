class_name BoardList extends PanelContainer

const BOARD_BUTTON = preload("res://scenes/elements/board_button/board_button.tscn")

var boards: Dictionary[String, Array]

@onready var board_container: VBoxContainer = $ScrollContainer/BoardContainer


func _ready() -> void:
	boards.set("Test Board", ["127.0.0.1", 3037])
	boards.set("Test Board 2", ["127.0.0.1", 3037])
	
	for board in boards.keys():
		var button := BOARD_BUTTON.instantiate()
		board_container.add_child(button)
		button.board_selected.connect(_board_button_pressed.bind(boards.get(board)))
		
		button.set_label(board)


func _board_button_pressed(board_details: Array) -> void:
	OSCGlobals.get_client().ip_address = board_details.get(0)
	OSCGlobals.get_client().port = board_details.get(1)
