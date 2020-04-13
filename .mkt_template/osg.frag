#version 120

#pragma include shader/ntoy.frag
#pragma include shader/snoise.frag

void main( void )
{
    vec2 st = gl_FragCoord.xy / resolution;
    st *= 4.85;
    float c = snoise(st);
    c = c * 0.5 + 0.5;
    gl_FragColor = vec4(c);
}
