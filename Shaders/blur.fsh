//varying vec2 vertPos;
//uniform sampler2D u_textureCol;
//uniform vec2 u_textureSize;
//uniform float u_sigma;
//uniform int u_width;

//float CalcGauss( float x, float sigma )
//{
//    float coeff = 1.0 / (2.0 * 3.14157 * sigma);
//    float expon = -(x*x) / (2.0 * sigma);
//    return (coeff*exp(expon));
//}

void main() {
//    vec2 u_textureSize = resolution * 2;
//    float u_sigma = 10;
//    int u_width = 100; //radius; //3; //100;
//    vec2 texC = v_tex_coord; // * vec2(1,1);
//    vec4 texCol = texture2D( u_texture, texC );
//    vec4 gaussCol = vec4( texCol.rgb, 1.0 );
//    vec2 step = 1.0 / u_textureSize;
//
//    for ( int i = 1; i <= u_width; ++ i )
//    {
//        vec2 actStep;
//        if(direction.z > 0.5){
//            actStep = vec2( float(i) * step.x * direction.x, float(i) * step.x * direction.y );
//        }else{
//            actStep = vec2( float(i) * step.x * -direction.x, float(i) * step.x * -direction.y );
//        }
//
//        float weight = CalcGauss( float(i) / float(u_width), u_sigma );
//        texCol = texture2D( u_texture, texC + actStep );
//        gaussCol += vec4( texCol.rgb * weight, weight );
//        texCol = texture2D( u_texture, texC - actStep );
//        gaussCol += vec4( texCol.rgb * weight, weight );
//    }
//    gaussCol.rgb /= gaussCol.w;
//    gl_FragColor = vec4( gaussCol.rgb, texCol.a * 2);
    
// =====================================================================================
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
    
    //gl_FragColor = blur13(u_texture, v_tex_coord, resolution, direction);
    
// =====================================================================================
    
//    float size = radius.x; //2;
//    float spread = radius.y * .001;
//    float divideby = 40; //30; //25.0;
//    vec4 sum = vec4(0.0);
//    int x ;
//    int y ;
//    vec4 color = texture2D(u_texture,v_tex_coord);
//
//    for (x = -size; x<= size; x++) {
//        for (y = -size; y<= size; y++) {
//            vec2 offset = vec2(x,y) * spread;
//            sum += texture2D(u_texture,v_tex_coord + offset);
//        }
//    }
//
//    sum *= tint; //vec4(1.0,0.0,0.0,0.0);
//
//    float alpha = min((color.a * 4), tint.a);
//    gl_FragColor = ( sum / divideby ) * alpha; // + color ;
    
// =====================================================================================
    
//    vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y);
//    vec3 color1 = vec3(0.0, 0.3, 0.5);
//    vec3 color2 = vec3(0.5, 0.0, 0.3);
//
//    float f = 0.0;
//    float g = 0.0;
//    float h = 0.0;
//    float PI = 3.14159265;
//    for(float i = 0.0; i < 40.0; i++){
////        if (floor(mouse.x * 41.0) < i)
////            break;
//        float s = sin(u_time + i * PI / 20.0) * 0.8;
//        float c = cos(u_time + i * PI / 20.0) * 0.8;
//        float d = abs(p.x + c);
//        float e = abs(p.y + s);
//        f += 0.001 / d;
//        g += 0.001 / e;
//        h += 0.00003 / (d * e);
//    }
//
//    gl_FragColor = vec4(f * color1 + g * color2 + vec3(h), 1.0);
}

