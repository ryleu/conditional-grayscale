#version 150

uniform float GameTime;

vec4 linear_fog(vec4 inColor, float vertexDistance, float fogStart, float fogEnd, vec4 fogColor) {
	vec4 fogged;
	
	// regular vanilla calculation
    if (vertexDistance <= fogStart) {
        fogged = inColor;
    } else {
   	    float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;
	    fogged = vec4(mix(inColor.rgb, fogColor.rgb, fogValue * fogColor.a), inColor.a);
	}
	
	if (GameTime < 0) {
		// apply grayscale
		fogged = vec4(vec3(dot(fogged.rgb, vec3(0.21, 0.72, 0.07))), fogged.a);
	}
	
	return fogged;
}

float linear_fog_fade(float vertexDistance, float fogStart, float fogEnd) {
    if (vertexDistance <= fogStart) {
        return 1.0;
    } else if (vertexDistance >= fogEnd) {
        return 0.0;
    }

    return smoothstep(fogEnd, fogStart, vertexDistance);
}

float fog_distance(mat4 modelViewMat, vec3 pos, int shape) {
    if (shape == 0) {
        return length((modelViewMat * vec4(pos, 1.0)).xyz);
    } else {
        float distXZ = length((modelViewMat * vec4(pos.x, 0.0, pos.z, 1.0)).xyz);
        float distY = length((modelViewMat * vec4(0.0, pos.y, 0.0, 1.0)).xyz);
        return max(distXZ, distY);
    }
}
