void main() {
   float size = radius.x; //2;	
   float spread = radius.y * .001;
   float divideby = 40; //30; //25.0;
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

   sum *= tint; //vec4(1.0,0.0,0.0,0.0);

   float alpha = min((color.a * 4), tint.a);
   gl_FragColor = ( sum / divideby ) * alpha; // + color ;
}