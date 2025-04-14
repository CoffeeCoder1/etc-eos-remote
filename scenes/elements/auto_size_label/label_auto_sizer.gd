class_name LabelAutoSizer


static func get_text_paragraph() -> TextParagraph:
	var line := TextParagraph.new()
	line.justification_flags = TextServer.JUSTIFICATION_NONE
	line.alignment = HORIZONTAL_ALIGNMENT_LEFT
	
	return line


static func update_font_size_by_height(label: AutoSizeLabel) -> void:
	var font_size_range := Vector2i(label.min_font_size, label.max_font_size)
	var font := label.get_theme_font("font")
	
	var paragraph := get_text_paragraph()
	paragraph.width = label.size.x
	paragraph.break_flags = TextServer.BREAK_MANDATORY | TextServer.BREAK_WORD_BOUND | TextServer.BREAK_ADAPTIVE
	
	while true:
		paragraph.clear()
		
		var mid_font_size := font_size_range.x + roundi((font_size_range.y - font_size_range.x) * 0.5)
		if !paragraph.add_string(label.text, font, mid_font_size):
			push_warning("Could not create a string!")
			return
		
		var text_height: int = paragraph.get_size().y
		
		if text_height > label.size.y:
			if font_size_range.y == mid_font_size:
				break
			
			font_size_range.y = mid_font_size
		
		if text_height <= label.size.y:
			if font_size_range.x == mid_font_size:
				break
			
			font_size_range.x = mid_font_size
	label.add_theme_font_size_override("font_size", font_size_range.x)
	
	# Detect if lines got clipped. If yes, force it to reduce size to fit inside the original.
	if not Engine.is_editor_hint():
		while label.get_visible_line_count() < label.get_line_count():
			font_size_range.x -= 1
			if font_size_range.x < label.min_font_size:
				break
			label.add_theme_font_size_override("font_size", font_size_range.x)
