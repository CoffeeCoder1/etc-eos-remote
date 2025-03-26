class_name ChannelFader extends Control

@onready var label: Label = $VBoxContainer/Label
@onready var slider: VSlider = $VBoxContainer/Slider

## Emitted when the channel value changes.
signal value_changed(value: float)

## The last value. Used to prevent snapback when moving manually.
var last_value: float


## Sets the value of the fader. Only sets the value if it changed to prevent the fader from snapping
## back to its previous value when moved until feedback is recieved from the server.
func set_value(value: float) -> void:
	if value != last_value:
		slider.set_value_no_signal(value)
		last_value = value


## Sets the label of the fader.
func set_label(text: String) -> void:
	label.text = text


func _on_slider_value_changed(value: float) -> void:
	value_changed.emit(value)
