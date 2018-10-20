// 13.glsl
// https://github.com/Jam3/glsl-fast-gaussian-blur 
void main() {
//    vec4 texCol = texture2D( u_texture, v_tex_coord );
//    vec4 color = vec4(0.0);
//    vec2 off1 = vec2(1.411764705882353) * direction.xy;
//    vec2 off2 = vec2(3.2941176470588234) * direction.xy;
//    vec2 off3 = vec2(5.176470588235294) * direction.xy;
//    color += texture2D(u_texture, v_tex_coord) * 0.1964825501511404;
//    color += texture2D(u_texture, v_tex_coord + (off1 / resolution)) * 0.2969069646728344;
//    color += texture2D(u_texture, v_tex_coord - (off1 / resolution)) * 0.2969069646728344;
//    color += texture2D(u_texture, v_tex_coord + (off2 / resolution)) * 0.09447039785044732;
//    color += texture2D(u_texture, v_tex_coord - (off2 / resolution)) * 0.09447039785044732;
//    color += texture2D(u_texture, v_tex_coord + (off3 / resolution)) * 0.010381362401148057;
//    color += texture2D(u_texture, v_tex_coord - (off3 / resolution)) * 0.010381362401148057;
//
//    color *= tint;
//    float alpha = min((color.a * 4.0), tint.a);
//    gl_FragColor = color * alpha;
    
    
    
    //=======================================================
    // boxblur
    //=======================================================
    vec4 texCol = texture2D( u_texture, v_tex_coord );
    vec4 color = vec4(0.0);
    
    vec2 step = direction.xy / resolution; //vec2(radius.x / resolution.x, radius.y / resolution.y);
    
    // default to tap9
    bool tap25 = false;
    
    //color += texture2D(u_texture, v_tex_coord + step); // * 0.1964825501511404;
    color += texture2D(u_texture, v_tex_coord + step * vec2(0.0, -1.0)); // * 0.2969069646728344;
    color += texture2D(u_texture, v_tex_coord + step * vec2(0.0, 1.0)); // * 0.2969069646728344;
    
    color += texture2D(u_texture, v_tex_coord + step * vec2(-1.0, 0.0)); // * 0.09447039785044732;
    color += texture2D(u_texture, v_tex_coord + step * vec2(-1.0, -1.0)); // * 0.09447039785044732;
    color += texture2D(u_texture, v_tex_coord + step * vec2(-1.0, 1.0)); // * 0.010381362401148057;
    
    color += texture2D(u_texture, v_tex_coord + step * vec2(1.0, 0.0)); // * 0.09447039785044732;
    color += texture2D(u_texture, v_tex_coord + step * vec2(1.0, -1.0)); // * 0.010381362401148057;
    color += texture2D(u_texture, v_tex_coord + step * vec2(1.0, 1.0)); // * 0.010381362401148057;
    
    if(tap25){
        color += texture2D(u_texture, v_tex_coord + step * vec2(0.0, -2.0));
        color += texture2D(u_texture, v_tex_coord + step * vec2(0.0, 2.0));
        color += texture2D(u_texture, v_tex_coord + step * vec2(-1.0, -2.0));
        color += texture2D(u_texture, v_tex_coord + step * vec2(-1.0, 2.0));
        color += texture2D(u_texture, v_tex_coord + step * vec2(1.0, -2.0));
        color += texture2D(u_texture, v_tex_coord + step * vec2(1.0, 2.0));
        
        color += texture2D(u_texture, v_tex_coord + step * vec2(-2.0, 0.0));
        color += texture2D(u_texture, v_tex_coord + step * vec2(-2.0, -1.0));
        color += texture2D(u_texture, v_tex_coord + step * vec2(-2.0, 1.0));
        color += texture2D(u_texture, v_tex_coord + step * vec2(-2.0, -2.0));
        color += texture2D(u_texture, v_tex_coord + step * vec2(-2.0, 2.0));
        
        color += texture2D(u_texture, v_tex_coord + step * vec2(2.0, 0.0));
        color += texture2D(u_texture, v_tex_coord + step * vec2(2.0, -1.0));
        color += texture2D(u_texture, v_tex_coord + step * vec2(2.0, 1.0));
        color += texture2D(u_texture, v_tex_coord + step * vec2(2.0, -2.0));
        color += texture2D(u_texture, v_tex_coord + step * vec2(2.0, 2.0));
    }
    
    float divisor = (tap25 ? 25.0 : 9.0);
    color = color / (divisor * .5);
    
    color *= tint * 2.0;
    
    float alpha = min((texCol.a * 4.0), tint.a);
    // cutout
//    if(alpha >= 0.9){
//        alpha = 0;
//    }else {
//
//    }
    color *= alpha;
    gl_FragColor = color;
    
    //=======================================================

    
    // nearest neighbor filter (downsamples / pixellates)
//    vec2 texSize = resolution / vec2(4.0);
//    vec2 pixel = v_tex_coord * texSize;
//    vec2 c_onePixel = 1.0 / texSize;
//    pixel = (floor(pixel) / texSize);
//    gl_FragColor = texture2D(u_texture, pixel + vec2(c_onePixel/2.0));
}
