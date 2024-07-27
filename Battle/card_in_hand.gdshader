shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
	
	COLOR=vec4(0.3,0,0,0.5);
}

void fragment() {
	// Called for every pixel the material is visible on.
	//ALBEDO = vec3(0.1, 0.3, 0.5)+COLOR.r;
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
