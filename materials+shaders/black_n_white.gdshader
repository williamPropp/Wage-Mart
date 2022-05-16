shader_type canvas_item;

uniform float weight = 1.0;

void fragment() {
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
//	vec4 old_color = COLOR
//	COLOR.rgb = vec3(COLOR.r + COLOR.g + COLOR.b) / 3.0;
//	COLOR.rbg = vec3(COLOR.r * old_color.r, COLOR.g * old_color.g, COLOR.b * old_color.b);
//	vec3 greyscale = vec3(COLOR.r + COLOR.g + COLOR.b) / 3.0;
//	COLOR.rgb = COLOR.rgb * greyscale * greyscale;
	float luma = 0.3*COLOR.r + 0.6*COLOR.g + 0.1*COLOR.b;
	float new_r = COLOR.r + weight * (luma - COLOR.r);
	float new_g = COLOR.g + weight * (luma - COLOR.g);
	float new_b = COLOR.b + weight * (luma - COLOR.b);
	COLOR.rgb = vec3(new_r, new_g, new_b);
}