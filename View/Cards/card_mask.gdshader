shader_type canvas_item;

// The mask texture defining your card window shape
uniform sampler2D mask_texture : hint_default_white, filter_linear;

void fragment() {
	// Sample the card portrait image
	vec4 portrait_color = texture(TEXTURE, UV);
	
	// Sample the mask texture
	vec4 mask_color = texture(mask_texture, UV);
	
	// Cut out the portrait:
	// Works whether your mask uses transparency (alpha) OR a black-and-white greyscale image
	float mask_value = mask_color.a * mask_color.r;
	
	COLOR = vec4(portrait_color.rgb, portrait_color.a * mask_value);
}
