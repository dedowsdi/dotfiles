#version 430 core

layout(location = 0) in vec4 pos;
layout(location = 1) in vec4 color;

layout(location = 0)uniform mat4 mvp_mat;

out vertex_data
{
  vec4 color;
} vo;

void main(void)
{
  gl_Position = mvp_mat * pos;
  vo.color = color;
}
