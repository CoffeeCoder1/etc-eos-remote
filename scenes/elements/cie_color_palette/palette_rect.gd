@tool
class_name PaletteRect extends TextureRect

@export var palette_type: PaletteType = PaletteType.CIE1931_xyY:
	set(new_palette_type):
		if is_node_ready():
			_set_palette_type(new_palette_type)
		palette_type = new_palette_type


const CIE1931_xyY_PALETTE_LINES = preload("res://assets/textures/color_palette/cie1931_palette_lines.svg")
const CIE1931_xyY_PALETTE_SHADER = preload("res://scenes/elements/cie_color_palette/xyY_palette.gdshader")

enum PaletteType {
	## CIE 1931 xyY palette.
	CIE1931_xyY,
}


func _ready() -> void:
	expand_mode = EXPAND_IGNORE_SIZE
	stretch_mode = STRETCH_KEEP_ASPECT
	material = ShaderMaterial.new()
	_set_palette_type(palette_type)


func _set_palette_type(palette_type: PaletteType) -> void:
	match (palette_type):
		PaletteType.CIE1931_xyY:
			texture = CIE1931_xyY_PALETTE_LINES
			material.set_shader(CIE1931_xyY_PALETTE_SHADER)
			material.set_shader_parameter("sRGB_TO_XYZ_COL0", CIE1931Constants.M_sRGB_TO_XYZ[0])
			material.set_shader_parameter("sRGB_TO_XYZ_COL1", CIE1931Constants.M_sRGB_TO_XYZ[1])
			material.set_shader_parameter("sRGB_TO_XYZ_COL2", CIE1931Constants.M_sRGB_TO_XYZ[2])
			#print_rich(material.get_shader_parameter("sRGB_TO_XYZ_COL0"))
