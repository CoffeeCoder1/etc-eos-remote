@tool
class_name RegExSyntaxHighlighter extends SyntaxHighlighter

## Patterns and colors, keys are patterns and values are colors.
@export var patterns: Array[RegExHighlightSymbol]
## The color used for regular text.
@export var default_color: Color = Color(1, 1, 1)


func _get_line_syntax_highlighting(line: int) -> Dictionary:
	var colors: Dictionary
	
	var regex = RegEx.new()
	
	for pattern in patterns:
		regex.compile(pattern.pattern)
		var mode_match = regex.search_all(get_text_edit().get_line(line))
		for regex_match in mode_match:
			colors[regex_match.get_start()] = { "color": pattern.color }
			colors[regex_match.get_end()] = { "color": default_color }
	
	return colors
