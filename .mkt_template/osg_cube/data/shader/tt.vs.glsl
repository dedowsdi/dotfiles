#version 430 core

layout(location = 0) in vec4 vertex;
layout(location = 2) in vec4 color;

layout(location = 0) uniform mat4 osg_ModelViewProjectionMatrix;

out vertex_data
{
  vec4 color;
}vo;

void main(void)
{
  gl_Position = osg_ModelViewProjectionMatrix * vertex;
  vo.color = color;
}
