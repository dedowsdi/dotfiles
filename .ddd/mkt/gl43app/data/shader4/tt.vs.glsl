#version 430 core

layout(location = 0) in vec4 pos;

layout(location = 0)uniform mat4 mvp_mat;

// out vertex_data
// {

// } vo;

void main(void)
{
  gl_Position = mvp_mat * pos;
}
