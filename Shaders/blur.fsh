// based on 13.glsl
// https://github.com/Jam3/glsl-fast-gaussian-blur

//// 2D Random
float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}
//// 2D Noise based on Morgan McGuire @morgan3d
//// https://www.shadertoy.com/view/4dS3Wd
//float noise (vec2 st) {
//    vec2 i = floor(st);
//    vec2 f = fract(st);
//
//    // Four corners in 2D of a tile
//    float a = random(i);
//    float b = random(i + vec2(1.0, 0.0));
//    float c = random(i + vec2(0.0, 1.0));
//    float d = random(i + vec2(1.0, 1.0));
//
//    // Smooth Interpolation
//
//    // Cubic Hermine Curve.  Same as SmoothStep()
//    vec2 u = f*f*(3.0-2.0*f);
//    // u = smoothstep(0.,1.,f);
//
//    // Mix 4 coorners percentages
//    return mix(a, b, u.x) +
//    (c - a)* u.y * (1.0 - u.x) +
//    (d - b) * u.x * u.y;
//}

float hash(vec2 p)  // replace this by something better
{
    p  = 50.0*fract( p*0.3183099 + vec2(0.71,0.113));
    return -1.0+2.0*fract( p.x*p.y*(p.x+p.y) );
}

float noise(vec2 p)
{
    vec2 i = floor( p );
    vec2 f = fract( p );
    
    vec2 u = f*f*(3.0-2.0*f);
    
    return mix( mix( hash( i + vec2(0.0,0.0) ),
                    hash( i + vec2(1.0,0.0) ), u.x),
               mix( hash( i + vec2(0.0,1.0) ),
                   hash( i + vec2(1.0,1.0) ), u.x), u.y);
}

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
    //color.rgb *= vec3(tint.a); // intensity
    
    
    /** uncomment for scanline effect */
    float scanlineIntensity = 0.3;
    float scanlineCount = 800.0;
    float scanlineYDelta = 1.0; //sin(u_time / 200.0);
    float _dot = dot(vec4(1.0, 1.0, 1.0, 0.0), color); // 3.0 for white, 0.0 for black
    float factor = 1.0 / 3.0  * _dot;
    if(float(_dot) > 0.0){
        float factor = 1.0 / 3.0  * _dot;
        float scanline = sin((v_tex_coord.y - scanlineYDelta) * scanlineCount) * (scanlineIntensity * factor);
        color -= scanline;
    }
    
    vec2 uv = v_tex_coord;
    
    if(float(factor) > 0.0000001){// && factor < .4){
        float f = 0.0;
        uv *= 20.0; // scale noise, higher = smaller/denser
        uv.xy += u_time; //random(u_time * 4); // * .1;
        mat2 m = mat2( 1.6,  1.2, -1.2,  1.6 );
        f  = 0.5000*noise( uv );
        uv = m*uv;
        f += 0.2500*noise( uv );
        uv = m*uv;
        f += 0.1250*noise( uv );
        uv = m*uv;
        f += 0.0625*noise( uv );
        uv = m*uv;
        f = 0.5 + 0.5*f; // scale intensity + normalize
        f = max(.5, f); // min

        //color = f;
        color.a *= f * (1.5-factor);
    }
    
    color.a = min(color.a, 0.6); // cap alpha
    color.rgb *= color.a; // pre-multiplied alpha
    gl_FragColor = color;
    
    //=======================================================

    
    // nearest neighbor filter (downsamples / pixellates)
//    vec2 texSize = resolution / vec2(4.0);
//    vec2 pixel = v_tex_coord * texSize;
//    vec2 c_onePixel = 1.0 / texSize;
//    pixel = (floor(pixel) / texSize);
//    gl_FragColor = texture2D(u_texture, pixel + vec2(c_onePixel/2.0));
}
