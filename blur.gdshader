shader_type canvas_item;
uniform sampler2D s:hint_screen_texture,filter_linear_mipmap_anisotropic;
uniform float mix_amount : hint_range(0.0, 1.0);
uniform vec4 color_over : source_color;
uniform float amount;
void fragment() {
	vec4 blurred = textureLod(s, SCREEN_UV, amount);
	vec4 fin = mix(blurred, color_over, mix_amount);
	COLOR = fin;
}

