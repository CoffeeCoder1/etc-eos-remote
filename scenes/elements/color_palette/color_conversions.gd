class_name ColorConversions extends Node

## Matrix used to convert sRGB to XYZ.
#const M_sRGB_TO_XYZ = [
#		[0.4124564, 0.3575761, 0.1804375],
#		[0.2126729, 0.7151522, 0.0721750],
#		[0.0193339, 0.1191920, 0.9503041],
#	]
const M_sRGB_TO_XYZ = [
		[0.4124564, 0.2126729, 0.0193339],
		[0.3575761, 0.7151522, 0.1191920],
		[0.1804375, 0.0721750, 0.9503041]
	];
## Matrix used to convert XYZ to sRGB.
const M_XYZ_TO_sRGB = [
		[3.2404542, -1.5371385, -0.4985314],
		[-0.9692660, 1.8760108, 0.0415560],
		[0.0556434, -0.2040259, 1.0572252],
	]
const M_BEST_XYZ_TO_sRGB = [
		[1.7552599, -0.4836786, -0.2530000],
		[-0.5441336, 1.5068789, 0.0215528],
		[0.0063467, -0.0175761, 1.2256959],
	]


## Takes a vector of (x, y, Y) and returns a vector of (X, Y, Z).
static func xyY_to_XYZ(color: Vector3) -> Vector3:
	# y = 0
	if (color.y == 0):
		return Vector3.ZERO
	
	var X: float = (color.x * color.z) / color.y
	var Y: float = color.z
	var Z: float = ((1.0 - color.x - color.y) * color.z) / color.y
	return Vector3(X, Y, Z)


## Takes a vector of (X, Y, Z) and returns a vector of (x, y, Y).
static func XYZ_to_xyY(color: Vector3) -> Vector3:
	# X = Y = Z = 0
	if (color == Vector3.ZERO):
		return Vector3.ZERO
	
	var x: float = color.x / (color.x + color.y + color.z)
	var y: float = color.y / (color.x + color.y + color.z)
	var Y: float = color.y
	return Vector3(x, y, Y)


## Takes a vector of (X, Y, Z) and converts it to a Color.
static func XYZ_to_color(color: Vector3) -> Color:
	var color_matrix := [
			[color.x],
			[color.y],
			[color.z],
		]
	var RGB = MatrixMath.matrix_multiply(M_XYZ_TO_sRGB, color_matrix)
	return Color(RGB[0][0], RGB[1][0], RGB[2][0]).clamp().linear_to_srgb()


## Takes a Color and converts it to a vector of (X, Y, Z).
static func color_to_XYZ(color: Color) -> Vector3:
	var color_matrix := [
			[color.r],
			[color.g],
			[color.b],
		]
	var XYZ = MatrixMath.matrix_multiply(M_sRGB_TO_XYZ, color_matrix)
	return Vector3(XYZ[0][0], XYZ[1][0], XYZ[2][0])


## Takes a vector of (x, y, Y) and converts it to a Color.
static func xyY_to_color(color: Vector3) -> Color:
	return XYZ_to_color(xyY_to_XYZ(color))


## Takes a vector of (x, y) and converts it to a Color.
static func xy_to_color(color: Vector2) -> Color:
	return xyY_to_color(Vector3(color.x, color.y, 1.0))


## Takes Color and converts it to a vector of (x, y, Y).
static func color_to_xyY(color: Color) -> Vector3:
	return XYZ_to_xyY(color_to_XYZ(color))


## Takes Color and converts it to a vector of (x, y).
static func color_to_xy(color: Color) -> Vector2:
	var color_xyY = color_to_xyY(color)
	return Vector2(color_xyY.x, color_xyY.y)
