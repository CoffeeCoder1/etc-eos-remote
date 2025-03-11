shader_type canvas_item;

/**
 * Column 0 of the sRGB to XYZ matrix.
 */
uniform vec3 sRGB_TO_XYZ_COL0 = vec3(0.4124564, 0.2126729, 0.0193339);
/**
 * Column 1 of the sRGB to XYZ matrix.
 */
uniform vec3 sRGB_TO_XYZ_COL1 = vec3(0.3575761, 0.7151522, 0.1191920);
/**
 * Column 2 of the sRGB to XYZ matrix.
 */
uniform vec3 sRGB_TO_XYZ_COL2 = vec3(0.1804375, 0.0721750, 0.9503041);

/**
 * Matrix used to convert from sRGB to XYZ color values.
 */
//const mat3 sRGB_TO_XYZ = mat3(
//		vec3(0.4124564, 0.2126729, 0.0193339),
//		vec3(0.3575761, 0.7151522, 0.1191920),
//		vec3(0.1804375, 0.0721750, 0.9503041)
//	);

float sRGBCompand(float value) {
	if (value >= 1.0) {
		return 1.0;
	} else {
		return value;
	}
	//return pow(value, 1.0 / 2.2);
	if (value <= 0.0031308) {
		return value * 12.92;
	} else {
		return 1.055 * pow(value, 1.0 / 2.4) - 0.055;
	}
}

vec3 xyYToXYZ(vec3 color) {
	if (color.y == 0.0){
		return vec3(0, 0, 0);
	}

	float X = (color.x * color.z) / color.y;
	float Y = color.z;
	float Z = ((1.0 - color.x - color.y) * color.z) / color.y;
	return vec3(X, Y, Z);
}

vec3 XYZToRGB(vec3 color) {
	mat3 sRGB_TO_XYZ = mat3(
		sRGB_TO_XYZ_COL0,
		sRGB_TO_XYZ_COL1,
		sRGB_TO_XYZ_COL2
	);
	vec3 colorRaw = inverse(sRGB_TO_XYZ) * color;
	float R = sRGBCompand(colorRaw.r);
	float G = sRGBCompand(colorRaw.g);
	float B = sRGBCompand(colorRaw.b);
	vec3 colorNormalized = vec3(R, G, B);
	return colorNormalized;
}

//void vertex() {}

void fragment() {
	vec2 scaledUV = vec2(UV.x, (UV.y - 1.0) * -1.0);
	vec3 colorXYZ = xyYToXYZ(vec3(scaledUV.x, scaledUV.y, 1.0));
	vec3 colorRGB = XYZToRGB(colorXYZ);
	COLOR = vec4(colorRGB, 1.0) * COLOR;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
