shader_type canvas_item;

uniform sampler2D gradient;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 n_col = texture(gradient, vec2(COLOR.r, 0)); 
	COLOR = vec4(n_col.rgb, COLOR.a);
}