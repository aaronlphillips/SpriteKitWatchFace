//varying vec2 vertPos;
//uniform sampler2D u_textureCol;
//uniform vec2 u_textureSize;
//uniform float u_sigma;
//uniform int u_width;

float CalcGauss( float x, float sigma )
{
   float coeff = 1.0 / (2.0 * 3.14157 * sigma);
   float expon = -(x*x) / (2.0 * sigma);
   return (coeff*exp(expon));
}

void main() {
   vec2 u_textureSize = resolution * 2;
   float u_sigma = 10;
   int u_width = 100; //radius; //3; //100;
   vec2 texC = v_tex_coord; // * vec2(1,1);
   vec4 texCol = texture2D( u_texture, texC );
   vec4 gaussCol = vec4( texCol.rgb, 1.0 );
   vec2 step = 1.0 / u_textureSize;

   for ( int i = 1; i <= u_width; ++ i )
   {
       vec2 actStep;
       if(direction.z > 0.5){
           actStep = vec2( float(i) * step.x * direction.x, float(i) * step.x * direction.y );
       }else{
           actStep = vec2( float(i) * step.x * -direction.x, float(i) * step.x * -direction.y );
       }

       float weight = CalcGauss( float(i) / float(u_width), u_sigma );
       texCol = texture2D( u_texture, texC + actStep );
       gaussCol += vec4( texCol.rgb * weight, weight );
       texCol = texture2D( u_texture, texC - actStep );
       gaussCol += vec4( texCol.rgb * weight, weight );
   }
   gaussCol.rgb /= gaussCol.w;
   gl_FragColor = vec4( gaussCol.rgb, texCol.a * 2);
}
