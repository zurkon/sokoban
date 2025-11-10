shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0);
uniform vec2 number_tiles = vec2(16, 9);
// Pixelate transition
uniform vec2 pixels_per_tile = vec2(16,16);
// Horizontal or Diagonal
uniform bool diagonal = true;

void fragment() {
	vec2 square_position = UV * number_tiles;
	vec2 pixel_position = round(square_position * pixels_per_tile);
	vec2 frac = fract(pixel_position / pixels_per_tile);
	vec2 direction = abs(frac - 0.5);
	
	if (diagonal) {
		// Diagonal Diamond Transition
		if(direction.x + direction.y + UV.x + UV.y  >= progress * 4.0) {
			discard;
		}
	} else {
		// Horizontal Diamond Transition
		if(direction.x + UV.x  >= progress * 2.0) {
			discard;
		}
	}
	
	// Diamond Transition
	//if(direction.x + direction.y  >= progress * 2.0) {
		//discard;
	//}
	
	// Diagonal Transition
	//if(UV.x + UV.y >= progress * 2.0) {
		//discard;
	//}
}