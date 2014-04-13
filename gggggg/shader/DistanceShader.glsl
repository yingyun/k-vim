attribute vec4 position;
attribute vec4 texCoords;
uniform mat4 projection;
attribute vec2 attr_inputTexcoords;
attribute vec2 attr_inputoffsetOne;
attribute vec2 attr_inputoffsetTwo;
varying vec2 inputTexcoords;
varying vec2 inputoffsetOne;
varying vec2 inputoffsetTwo;
void main() {
	gl_Position = projection * position;
	inputTexcoords = texCoords.st;
	//Update varying value
	inputTexcoords = attr_inputTexcoords;
	inputoffsetOne = attr_inputoffsetOne;
	inputoffsetTwo = attr_inputoffsetTwo;
}

sampler2D sampler;
varying vec2 inputTexcoords;
varying vec2 inputOffsetOne;
varying vec2 inputOffsetTwo;
uniform float weightCenter;
uniform float weightCentorTwo;
uniform float weightCentorOne;
vec4 colorWithWeight(vec2 texCoords, float colorWeight) {
	vec4 color = texture2D(sampler, texCoords);
	return color * colorWeight;
}
void main() {
	vec4 outputColor;
	outputColor = colorWithWeight(inputTexcoords, weightCenter);
	vec2 OffsetTwo;
	OffsetTwo = inputTexcoords - inputOffsetTwo;
	outputColor += colorWithWeight(OffsetTwo,  weightCentorTwo);
	vec2 OffsetOne;
	OffsetOne = inputTexcoords - inputOffsetOne;
	outputColor += colorWithWeight(OffsetOne,  weightCentorOne);
	OffsetOne = inputTexcoords + inputOffsetOne;
	outputColor += colorWithWeight(OffsetOne,  weightCentorOne);
	OffsetTwo = inputTexcoords + inputOffsetTwo;
	outputColor += colorWithWeight(OffsetTwo,  weightCentorTwo);
	gl_FragColor= outputColor;
}

