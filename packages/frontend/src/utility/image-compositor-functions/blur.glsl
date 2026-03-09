#version 300 es
precision mediump float;

/*
 * SPDX-FileCopyrightText: syuilo and misskey-project
 * SPDX-License-Identifier: AGPL-3.0-only
 */

const float PI = 3.141592653589793;
const float TWO_PI = 6.283185307179586;
const float HALF_PI = 1.5707963267948966;

in vec2 in_uv;
uniform sampler2D in_texture;
uniform vec2 in_resolution;
uniform vec2 u_offset;
uniform vec2 u_scale;
uniform bool u_ellipse;
uniform float u_angle;
uniform float u_radius;
uniform int u_samples;
out vec4 out_color;

<<<<<<< HEAD
void main() {
	float angle = -(u_angle * PI);
	vec2 centeredUv = in_uv - vec2(0.5, 0.5) - u_offset;
	vec2 rotatedUV = vec2(
		centeredUv.x * cos(angle) - centeredUv.y * sin(angle),
		centeredUv.x * sin(angle) + centeredUv.y * cos(angle)
	) + u_offset;
=======
float rand(vec2 value) {
	return fract(sin(dot(value, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
	float angle = -(u_angle * PI);
	float aspect = in_resolution.x / max(in_resolution.y, 1.0);
	vec2 centeredUv = in_uv - vec2(0.5, 0.5) - u_offset;
	vec2 scaledUv = vec2(centeredUv.x * aspect, centeredUv.y);
	vec2 rotatedScaledUv = vec2(
		scaledUv.x * cos(angle) - scaledUv.y * sin(angle),
		scaledUv.x * sin(angle) + scaledUv.y * cos(angle)
	);
	vec2 rotatedUV = vec2(rotatedScaledUv.x / aspect, rotatedScaledUv.y) + u_offset;
>>>>>>> misskey-dev-develop

	bool isInside = false;
	if (u_ellipse) {
		vec2 norm = (rotatedUV - u_offset) / u_scale;
		isInside = dot(norm, norm) <= 1.0;
	} else {
		isInside = rotatedUV.x > u_offset.x - u_scale.x && rotatedUV.x < u_offset.x + u_scale.x && rotatedUV.y > u_offset.y - u_scale.y && rotatedUV.y < u_offset.y + u_scale.y;
	}

	if (!isInside) {
		out_color = texture(in_texture, in_uv);
		return;
	}

	vec4 result = vec4(0.0);
	float totalSamples = 0.0;

	// Make blur radius resolution-independent by using a percentage of image size
<<<<<<< HEAD
	// This ensures consistent visual blur regardless of image resolution
	float referenceSize = min(in_resolution.x, in_resolution.y);
	float normalizedRadius = u_radius / 100.0; // Convert radius to percentage (0-15 -> 0-0.15)
	vec2 blurOffset = vec2(normalizedRadius) / in_resolution * referenceSize;

	// Calculate how many samples to take in each direction
	// This determines the grid density, not the blur extent
	int sampleRadius = int(sqrt(float(u_samples)) / 2.0);

	// Sample in a grid pattern within the specified radius
	for (int x = -sampleRadius; x <= sampleRadius; x++) {
		for (int y = -sampleRadius; y <= sampleRadius; y++) {
			// Normalize the grid position to [-1, 1] range
			float normalizedX = float(x) / float(sampleRadius);
			float normalizedY = float(y) / float(sampleRadius);

			// Scale by radius to get the actual sampling offset
			vec2 offset = vec2(normalizedX, normalizedY) * blurOffset;
			vec2 sampleUV = in_uv + offset;

			// Only sample if within texture bounds
			if (sampleUV.x >= 0.0 && sampleUV.x <= 1.0 && sampleUV.y >= 0.0 && sampleUV.y <= 1.0) {
				result += texture(in_texture, sampleUV);
				totalSamples += 1.0;
			}
=======
	float referenceSize = min(in_resolution.x, in_resolution.y);
	float normalizedRadius = u_radius / 100.0;
	float radiusPx = normalizedRadius * referenceSize;
	vec2 texelSize = 1.0 / in_resolution;

	int sampleCount = max(u_samples, 1);
	float sampleCountF = float(sampleCount);
	float jitter = rand(in_uv * in_resolution);
	float goldenAngle = 2.39996323;

	// Sample in a circular pattern to avoid axis-aligned artifacts
	for (int i = 0; i < sampleCount; i++) {
		float fi = float(i);
		float radius = sqrt((fi + 0.5) / sampleCountF);
		float theta = (fi + jitter) * goldenAngle;
		vec2 direction = vec2(cos(theta), sin(theta));
		vec2 offset = direction * (radiusPx * radius) * texelSize;
		vec2 sampleUV = in_uv + offset;

		if (sampleUV.x >= 0.0 && sampleUV.x <= 1.0 && sampleUV.y >= 0.0 && sampleUV.y <= 1.0) {
			float weight = exp(-radius * radius * 4.0);
			result += texture(in_texture, sampleUV) * weight;
			totalSamples += weight;
>>>>>>> misskey-dev-develop
		}
	}

	out_color = totalSamples > 0.0 ? result / totalSamples : texture(in_texture, in_uv);
}
