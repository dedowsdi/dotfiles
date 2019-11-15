#version 430 core

#define PI 3.1415926535897932384626433832795

in vertex_data
{
  vec4 color;
}fi;


out vec4 frag_color;

void main(void)
{
  frag_color = fi.color;
}
