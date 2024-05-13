shader_type canvas_item;
uniform vec4 c:source_color;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.rgb = c.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
