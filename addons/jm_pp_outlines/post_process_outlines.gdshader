shader_type spatial;
render_mode depth_draw_never, depth_test_disabled, unshaded, cull_disabled;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

uniform float depth_outline_scale = 2.0; // Size of depth outlines
uniform float depth_threshold : hint_range(0,10) = 2.5; // Controls sensitivity to depth changes (lower values mean more outlines, but more artifacts too)
uniform float depth_multiplier = 1000.0; // Multiplier for depth values
uniform float edge_threshold : hint_range(0,1) = 0.04; // General threshold for values to be considered as edges
uniform float max_edge_alpha : hint_range(0,1) = 0.8; // Max edge alpha, lower values means edges blend more with background
uniform float edge_alpha_multiplier = 3.0; // General multiplier for edge alpha value, higher values mean harder edges

uniform vec4 edge_color : source_color = vec4(0,0,0,1); // Outlines color
uniform sampler2D bgTex : source_color; // BG texture

uniform bool depth_use_laplace = true; // Sets depth edges to use the laplace operator instead of sobel
uniform bool use_bg_texture = false; // Sets shader to use render the BG behind the edges

varying mat4 CAMERA;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
	CAMERA = INV_VIEW_MATRIX;
}

float getDepthVal(sampler2D depthTex, vec2 depthUV, mat4 invProjMat) {
	float depth = texture(depthTex, depthUV).r;
	return depth;
}

void fragment() {
	float halfScaleFloor_d = floor(depth_outline_scale * 0.5);
	float halfScaleCeil_d = ceil(depth_outline_scale * 0.5);
	vec2 texelSize = vec2(1.0/VIEWPORT_SIZE.x, 1.0/VIEWPORT_SIZE.y);
	
	vec2 bottomLeftUV_d = SCREEN_UV - vec2(texelSize.x, texelSize.y) * halfScaleFloor_d;
	vec2 topRightUV_d = SCREEN_UV + vec2(texelSize.x, texelSize.y) * halfScaleCeil_d;
	vec2 topUV_d = SCREEN_UV + vec2(0.0, texelSize.y * halfScaleCeil_d);
	vec2 bottomUV_d = SCREEN_UV + vec2(0.0, -texelSize.y * halfScaleFloor_d);
	vec2 rightUV_d = SCREEN_UV + vec2(texelSize.x * halfScaleCeil_d, 0.0);
	vec2 leftUV_d = SCREEN_UV + vec2(-texelSize.x * halfScaleFloor_d, 0.0);
	vec2 bottomRightUV_d = SCREEN_UV + vec2(texelSize.x * halfScaleCeil_d, -texelSize.y * halfScaleFloor_d);
	vec2 topLeftUV_d = SCREEN_UV + vec2(-texelSize.x * halfScaleFloor_d, texelSize.y * halfScaleCeil_d);
	vec2 centerUV_d = SCREEN_UV;
	
	float d0 = getDepthVal(DEPTH_TEXTURE, topLeftUV_d, INV_PROJECTION_MATRIX);
	float d1 = getDepthVal(DEPTH_TEXTURE, topUV_d, INV_PROJECTION_MATRIX);
	float d2 = getDepthVal(DEPTH_TEXTURE, topRightUV_d, INV_PROJECTION_MATRIX);
	float d3 = getDepthVal(DEPTH_TEXTURE, leftUV_d, INV_PROJECTION_MATRIX);
	float d4 = getDepthVal(DEPTH_TEXTURE, centerUV_d, INV_PROJECTION_MATRIX);
	float d5 = getDepthVal(DEPTH_TEXTURE, rightUV_d, INV_PROJECTION_MATRIX);
	float d6 = getDepthVal(DEPTH_TEXTURE, bottomLeftUV_d, INV_PROJECTION_MATRIX);
	float d7 = getDepthVal(DEPTH_TEXTURE, bottomUV_d, INV_PROJECTION_MATRIX);
	float d8 = getDepthVal(DEPTH_TEXTURE, bottomRightUV_d, INV_PROJECTION_MATRIX);
	
	float edgeDepth = 0.0;
	if (depth_use_laplace) {
		 edgeDepth = (8.0 * d4 - (d0+d1+d2+d3+d5+d6+d7+d8)) * depth_multiplier;
	}
	else {
		float d_sobel_edge_h = (d2 + (2.0*d5) + d8 - (d0 + (2.0*d3) + d6)) / 4.0;
  		float d_sobel_edge_v = (d0 + (2.0*d1) + d2 - (d6 + (2.0*d7) + d8)) / 4.0;
		edgeDepth = sqrt((d_sobel_edge_h * d_sobel_edge_h) + (d_sobel_edge_v * d_sobel_edge_v)) * depth_multiplier;
	}
	
	float depthThreshold = depth_threshold * d0;
	edgeDepth = smoothstep(depthThreshold-depthThreshold/5.0, depthThreshold, edgeDepth);
	
	float edgeVal = edgeDepth;
	
	if (edgeVal > edge_threshold) {
		if (use_bg_texture) {
			ALBEDO = edge_color.rgb * texture(bgTex, -SCREEN_UV).rgb;
		}
		else {
			ALBEDO = -edge_color.rgb;
			ALPHA = min(max_edge_alpha,edgeVal * edge_alpha_multiplier);
		}
		
	}
	else {
		if (use_bg_texture) {
			ALBEDO = texture(bgTex, SCREEN_UV).rgb;
		}
		else {
			ALPHA = 0.0;
		}
	}
}