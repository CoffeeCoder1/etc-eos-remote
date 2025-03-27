class_name Settings extends Resource

## User index to use when connecting to the board.
@export var user_id: int = -1:
	set(new_user_id):
		user_id_set.emit(new_user_id)
		user_id = new_user_id
		settings_updated.emit()
## Enables relative control of wheels.
@export var wheel_mode: Wheel.WheelMode = Wheel.WheelMode.RELATIVE:
	set(new_wheel_mode):
		Globals.set_wheel_modes(new_wheel_mode)
		wheel_mode = new_wheel_mode
		settings_updated.emit()
## The list of boards to choose from.
@export var board_list: Array[BoardSettings]

## Emitted when a new user ID is set.
signal user_id_set(user_id: int)
## Emitted when the settings are updated and need to be saved.
signal settings_updated


func get_wheel_mode() -> Wheel.WheelMode:
	return wheel_mode


func set_wheel_mode(new_wheel_mode: Wheel.WheelMode) -> void:
	wheel_mode = new_wheel_mode


func get_user_id() -> int:
	return user_id


func set_user_id(new_user_id: int) -> void:
	user_id = new_user_id


func get_board_list() -> Array[BoardSettings]:
	return board_list


func add_board(board: BoardSettings) -> void:
	board_list.append(board)
	settings_updated.emit()


func remove_board(board: BoardSettings) -> void:
	board_list.erase(board)
	settings_updated.emit()
