// 13.glsl
// https://github.com/Jam3/glsl-fast-gaussian-blur 
void main() {
    vec4 texCol = texture2D( u_texture, v_tex_coord );
    vec4 color = vec4(0.0);
    vec2 off1 = vec2(1.411764705882353) * direction.xy;
    vec2 off2 = vec2(3.2941176470588234) * direction.xy;
    vec2 off3 = vec2(5.176470588235294) * direction.xy;
    color += texture2D(u_texture, v_tex_coord) * 0.1964825501511404;
    color += texture2D(u_texture, v_tex_coord + (off1 / resolution)) * 0.2969069646728344;
    color += texture2D(u_texture, v_tex_coord - (off1 / resolution)) * 0.2969069646728344;
    color += texture2D(u_texture, v_tex_coord + (off2 / resolution)) * 0.09447039785044732;
    color += texture2D(u_texture, v_tex_coord - (off2 / resolution)) * 0.09447039785044732;
    color += texture2D(u_texture, v_tex_coord + (off3 / resolution)) * 0.010381362401148057;
    color += texture2D(u_texture, v_tex_coord - (off3 / resolution)) * 0.010381362401148057;
    
    color *= tint;
    float alpha = min((color.a * 4.0), tint.a);
    gl_FragColor = color * alpha;
}