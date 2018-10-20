void main() {
    float size = 3; //2;
    float spread = .005;
    float divideby = 30; //25.0;
    vec4 sum = vec4(0.0);
    int x ;
    int y ;
    vec4 color = texture2D(u_texture,v_tex_coord);
    
    for (x = -size; x<= size; x++) {
        for (y = -size; y<= size; y++) {
            vec2 offset = vec2(x,y) * spread;
            sum += texture2D(u_texture,v_tex_coord + offset);
        }
    }
    
    gl_FragColor = ( sum / divideby ); // * color.a; // + color ;
}
