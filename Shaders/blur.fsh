// based on 13.glsl
// https://github.com/Jam3/glsl-fast-gaussian-blur 
void main() {
    //=======================================================
    // hybrid box/gaussian blur
    //=======================================================
    vec4 texCol = texture2D( u_texture, v_tex_coord );
    vec4 color = vec4(0.0);
    
    color += texture2D(u_texture, v_tex_coord) * 0.2;
    
    // Horiz
    color += texture2D(u_texture, v_tex_coord + vec2(steps.x,0)) * 0.2;
    color += texture2D(u_texture, v_tex_coord - vec2(steps.x,0)) * 0.2;
    color += texture2D(u_texture, v_tex_coord + vec2(steps.z,0)) * 0.2;
    color += texture2D(u_texture, v_tex_coord - vec2(steps.z,0)) * 0.2;
    
//    color += texture2D(u_texture, v_tex_coord + vec2(steps2.x,0)) * 0.1;
//    color += texture2D(u_texture, v_tex_coord - vec2(steps2.x,0)) * 0.1;
//    color += texture2D(u_texture, v_tex_coord + vec2(steps2.z,0)) * 0.1;
//    color += texture2D(u_texture, v_tex_coord - vec2(steps2.z,0)) * 0.1;
    
    // Vert
    color += texture2D(u_texture, v_tex_coord + vec2(0,steps.y)) * 0.2;
    color += texture2D(u_texture, v_tex_coord - vec2(0,steps.y)) * 0.2;
    color += texture2D(u_texture, v_tex_coord + vec2(0,steps.w)) * 0.2;
    color += texture2D(u_texture, v_tex_coord - vec2(0,steps.w)) * 0.2;
    
//    color += texture2D(u_texture, v_tex_coord + vec2(0,steps2.y)) * 0.1;
//    color += texture2D(u_texture, v_tex_coord - vec2(0,steps2.y)) * 0.1;
//    color += texture2D(u_texture, v_tex_coord + vec2(0,steps2.w)) * 0.1;
//    color += texture2D(u_texture, v_tex_coord - vec2(0,steps2.w)) * 0.1;
    
    // Diag NE SW
    color += texture2D(u_texture, v_tex_coord + steps2.xx) * 0.15;
    color += texture2D(u_texture, v_tex_coord - steps2.xx) * 0.15;
    color += texture2D(u_texture, v_tex_coord + steps2.zz) * 0.15;
    color += texture2D(u_texture, v_tex_coord - steps2.zz) * 0.15;
    
//    color += texture2D(u_texture, v_tex_coord + steps2.xx) * 0.05;
//    color += texture2D(u_texture, v_tex_coord - steps2.xx) * 0.05;
//    color += texture2D(u_texture, v_tex_coord + steps2.zz) * 0.05;
//    color += texture2D(u_texture, v_tex_coord - steps2.zz) * 0.05;

    // Diag NW SE
    color += texture2D(u_texture, v_tex_coord + vec2(steps2.x,-steps2.x)) * 0.15;
    color += texture2D(u_texture, v_tex_coord - vec2(steps2.x,-steps2.x)) * 0.15;
    color += texture2D(u_texture, v_tex_coord + vec2(steps2.w,-steps2.w)) * 0.15;
    color += texture2D(u_texture, v_tex_coord - vec2(steps2.w,-steps2.w)) * 0.15;
    
//    color += texture2D(u_texture, v_tex_coord + vec2(steps2.x,-steps2.x)) * 0.05;
//    color += texture2D(u_texture, v_tex_coord - vec2(steps2.x,-steps2.x)) * 0.05;
//    color += texture2D(u_texture, v_tex_coord + vec2(steps2.w,-steps2.w)) * 0.05;
//    color += texture2D(u_texture, v_tex_coord - vec2(steps2.w,-steps2.w)) * 0.05;

    color.rgb *= tint.rgb;
    color.rgb *= vec3(tint.a); // intensity
    color.a *= 1.0 - max(color.a, tint.a);
    
    float scanlineIntensity = .5;
    float scanlineCount = 400;
    float scanlineYDelta = sin(u_time / 200.0);
    
    float _dot = dot(vec4(1.0, 1.0, 1.0, 0.0), color); // 3.0 for white, 0.0 for black
    if(_dot > 0){
        float factor = 1.0 / 3.0  * _dot;
        float scanline = sin((v_tex_coord.y - scanlineYDelta) * scanlineCount) * (scanlineIntensity * factor);
        color -= scanline;
    }
    
    
    gl_FragColor = color;
    
    //=======================================================

    
    // nearest neighbor filter (downsamples / pixellates)
//    vec2 texSize = resolution / vec2(4.0);
//    vec2 pixel = v_tex_coord * texSize;
//    vec2 c_onePixel = 1.0 / texSize;
//    pixel = (floor(pixel) / texSize);
//    gl_FragColor = texture2D(u_texture, pixel + vec2(c_onePixel/2.0));
}
