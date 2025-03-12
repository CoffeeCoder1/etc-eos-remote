@tool
class_name AutoSizeLabel extends Label

@export var min_font_size := 8:
	set(v):
		min_font_size = clampi(v, 1, max_font_size)
		update()
@export var max_font_size := 16:
	set(v):
		max_font_size = clampi(v, min_font_size, 191)
		update()


func _ready() -> void:
	clip_text = true
	item_rect_changed.connect(update)


func _set(property: StringName, value: Variant) -> bool:
	# Listen for changes to text.
	if property == "text":
		text = value
		update()
		return true
	
	return false


func update() -> void:
	return LabelAutoSizer.update_font_size_by_height(self)
