#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
// Custom
out float isTop;
out float isShadow;
out float cType;

void custom(int type) {
    cType = type;
    int vertex = gl_VertexID%4;
    isTop = (vertex == 0 || vertex == 3) ? 1 : 0;
}

void main() {
    // vanilla behavior
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
    // Custom
    cType = 0;
    if (
        Position.z == 0.03 || // Actionbar
        Position.z == 0.06 || // Subtitle
        Position.z == 0.12 || // Title
        Position.z == 100.03 || // Chat
        Position.z == 200.03 || // Advancement Screen
        Position.z == 400.03    // Items
        ) { // Regular Text
        isShadow = 0;
        ivec3 iColor = ivec3(Color.xyz * 255.1);
        if (iColor == ivec3(78, 92, 36)) { vertexColor.rgb = texelFetch(Sampler2, UV2 / 16, 0).rgb; } else
        if (iColor == ivec3(59, 43,  6)) { custom(1); } else
        if (iColor == ivec3(33, 25,  5)) { custom(2); } else
        if (iColor == ivec3(64, 51,  3)) { custom(3); }

    } else if (
        Position.z == 0 || // Actionbar | Subtitle | Title
        Position.z == 100 || // Chat
        Position.z == 200 || // Advancement Screen
        Position.z == 400    // Items
        ) { // Shadow
        isShadow = 1;
        ivec3 iColor = ivec3(Color.xyz * 255.1);
        if (iColor == ivec3(19, 23, 9)) { gl_Position = vec4(2,2,2,1); } else
        if (iColor == ivec3(14, 10, 1)) { custom(1); } else
        if (iColor == ivec3( 8,  6, 1)) { custom(2); } else
        if (iColor == ivec3(16, 12, 0)) { custom(3); }
    }
}
