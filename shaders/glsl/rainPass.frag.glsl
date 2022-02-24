#define PI 3.14159265359
#ifdef GL_OES_standard_derivatives
#extension GL_OES_standard_derivatives: enable
#endif
precision lowp float;

uniform sampler2D state;
uniform float numColumns, numRows;
uniform sampler2D glyphTex;
uniform float glyphHeightToWidth, glyphSequenceLength, glyphEdgeCrop;
uniform vec2 glyphTextureGridSize;
uniform vec2 slantVec;
uniform float slantScale;
uniform bool isPolar;
uniform bool showComputationTexture;
uniform bool volumetric;

varying vec2 vUV;
varying vec3 vChannel;
varying vec4 vGlyph;

float median3(vec3 i) {
	return max(min(i.r, i.g), min(max(i.r, i.g), i.b));
}

vec2 getSymbolUV(float glyphCycle) {
	float symbol = floor((glyphSequenceLength) * glyphCycle) + 1.0;
	float symbolX = mod(symbol, glyphTextureGridSize.x) - 1.0;
	float symbolY = glyphTextureGridSize.y - 1.0 - (mod(floor(symbol / glyphTextureGridSize.x), glyphTextureGridSize.y));
	return vec2(symbolX, symbolY);
}

void main() {

	vec2 uv = vUV;

	// In normal mode, derives the current glyph and UV from vUV
	if (!volumetric) {
		if (isPolar) {
			// Curved space that makes letters appear to radiate from up above
			uv -= 0.5;
			uv *= 0.5;
			uv.y -= 0.5;
			float radius = length(uv);
			float angle = atan(uv.y, uv.x) / (2. * PI) + 0.5;
			uv = vec2(fract(angle * 4. - 0.5), 1.5 * (1. - sqrt(radius)));
		} else {
			// Applies the slant and scales space so the viewport is fully covered
			uv = vec2(
				(uv.x - 0.5) * slantVec.x + (uv.y - 0.5) * slantVec.y,
				(uv.y - 0.5) * slantVec.x - (uv.x - 0.5) * slantVec.y
			) * slantScale + 0.5;
		}
		uv.y /= glyphHeightToWidth;
	}

	// Unpack the values from the data texture
	vec4 glyph = volumetric ? vGlyph : texture2D(state, uv);
	float brightness = glyph.r;
	vec2 symbolUV = getSymbolUV(glyph.g);
	float quadDepth = glyph.b;
	float effect = glyph.a;

	brightness = max(effect, brightness);
	// In volumetric mode, distant glyphs are dimmer
	if (volumetric) {
		brightness = brightness * min(1.0, quadDepth);
	}

	// resolve UV to cropped position of glyph in MSDF texture
	vec2 glyphUV = fract(uv * vec2(numColumns, numRows));
	glyphUV -= 0.5;
	glyphUV *= clamp(1.0 - glyphEdgeCrop, 0.0, 1.0);
	glyphUV += 0.5;
	vec2 msdfUV = (glyphUV + symbolUV) / glyphTextureGridSize;

	// MSDF: calculate brightness of fragment based on distance to shape
	vec3 dist = texture2D(glyphTex, msdfUV).rgb;
	float sigDist = median3(dist) - 0.5;
	float alpha = clamp(sigDist/fwidth(sigDist) + 0.5, 0.0, 1.0);

	if (showComputationTexture) {
		vec4 debugColor = vec4(glyph.r - alpha, glyph.g * alpha, glyph.a - alpha, 1.0);
		if (volumetric) {
			debugColor.g = debugColor.g * 0.9 + 0.1;
		}
		gl_FragColor = debugColor;
	} else {
		gl_FragColor = vec4(vChannel * brightness * alpha, 1.0);
	}

}
