#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
// Custom
uniform vec2 ScreenSize;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
// Custom
in float isTop;
in float isShadow;
in float cType;

out vec4 fragColor;

// https://gist.github.com/mairod/a75e7b44f68110e1576d77419d608786
vec3 hueShift( vec3 color, float hueAdjust ){

    const vec3  kRGBToYPrime = vec3 (0.299, 0.587, 0.114);
    const vec3  kRGBToI      = vec3 (0.596, -0.275, -0.321);
    const vec3  kRGBToQ      = vec3 (0.212, -0.523, 0.311);

    const vec3  kYIQToR     = vec3 (1.0, 0.956, 0.621);
    const vec3  kYIQToG     = vec3 (1.0, -0.272, -0.647);
    const vec3  kYIQToB     = vec3 (1.0, -1.107, 1.704);

    float   YPrime  = dot (color, kRGBToYPrime);
    float   I       = dot (color, kRGBToI);
    float   Q       = dot (color, kRGBToQ);
    float   hue     = atan (Q, I);
    float   chroma  = sqrt (I * I + Q * Q);

    hue += hueAdjust;

    Q = chroma * sin (hue);
    I = chroma * cos (hue);

    vec3    yIQ   = vec3 (YPrime, I, Q);

    return vec3( dot (yIQ, kYIQToR), dot (yIQ, kYIQToG), dot (yIQ, kYIQToB) );
}

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    // custom
    switch (int(cType+0.5)) {
        case 1: // special red
            vec3 topRed = vec3(252/255., 239/255., 112/255.);
            vec3 midRed = vec3(246/255.,  77/255.,  41/255.);
            vec3 botRed = vec3( 43/255.,  15/255.,  19/255.);
            color.rgb = isTop < 0.5 ? mix(botRed, midRed, isTop*2) : mix(midRed, topRed, isTop*2-1);
            if (int(isShadow+0.5) == 1) color.rgb = color.rgb/4;
            break;
        case 2: // special blue
            vec3 topBlue = vec3(138/255., 230/255., 233/255.);
            vec3 midBlue = vec3( 39/255., 103/255., 180/255.);
            vec3 botBlue = vec3(  2/255.,  31/255., 114/255.);
            color.rgb = isTop < 0.5 ? mix(botBlue, midBlue, isTop*2) : mix(midBlue, topBlue, isTop*2-1);
            if (int(isShadow+0.5) == 1) color.rgb = color.rgb/4;
            break;
        case 3: // special rainbow
            float scrollSpeed = 600; float rainbowWidth = 0.2; float angle = 7;
            color.rgb = hueShift(vec3(1,0.4,0.4), fract(
                gl_FragCoord.x / (ScreenSize.x * rainbowWidth) + // Left/Right offset
                GameTime * scrollSpeed + // Time offset
                isTop / angle // Up/Down offset
                )*13/2);
            if (int(isShadow+0.5) == 1) { color.rgb = color.rgb/4; }
            break;
    }
    // vanilla
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
