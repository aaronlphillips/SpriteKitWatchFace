void main() {
	vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y);
	vec3 color1 = vec3(0.0, 0.3, 0.5);
	vec3 color2 = vec3(0.5, 0.0, 0.3);

	float f = 0.0;
	float g = 0.0;
	float h = 0.0;
	float PI = 3.14159265;
	for(float i = 0.0; i < 40.0; i++){
	//        if (floor(mouse.x * 41.0) < i)
	//            break;
	   float s = sin(u_time + i * PI / 20.0) * 0.8;
	   float c = cos(u_time + i * PI / 20.0) * 0.8;
	   float d = abs(p.x + c);
	   float e = abs(p.y + s);
	   f += 0.001 / d;
	   g += 0.001 / e;
	   h += 0.00003 / (d * e);
	}

	gl_FragColor = vec4(f * color1 + g * color2 + vec3(h), 1.0);
}	