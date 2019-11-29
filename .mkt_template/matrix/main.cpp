#include <sstream>
#include <iomanip>

#include <string_util.h>

#define GLM_ENABLE_EXPERIMENTAL
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtx/transform.hpp>

using namespace glm;

void print_matrix(const mat4& m, const std::string& title)
{
  std::cout << "--------------------------------------------------"
            << std::endl;
  std::cout << title << std::endl << std::endl;

  std::string::size_type w = 1;
  for (int i = 0; i < 4; ++i)
  {
    for (int j = 0; j < 4; j++)
    {
      w = glm::max(w, string_util::to(m[i][j]).length());
    }
  }

  w += 2;

  mat4 identity(1);
  // print column major row by row
  for (int i = 0; i < 4; ++i)
  {
    for (int j = 0; j < 4; j++)
    {
      if (m[j][i] != identity[j][i])
        std::cout << string_util::bash_inverse << std::setw(w) << m[j][i]
                  << string_util::bash_reset;
      else
        std::cout << std::setw(w) << m[j][i];
    }
    std::cout << std::endl;
  }
}

void print_vector(const vec4& v, const std::string& title)
{
  std::cout << "--------------------------------------------------"
            << std::endl;
  std::cout << title << std::endl << std::endl;

  for (int i = 0; i < 4; ++i)
  {
    std::cout << v[i] << " ";
  }
  std::cout << std::endl;

  if (v[3] != 0)
  {
    for (int i = 0; i < 4; ++i)
    {
      std::cout << v[i] / v[3] << " ";
    }
    std::cout << std::endl;
  }
}

int main(int argc, char* argv[])
{
  // viewport
  const auto x = 0;
  const auto y = 0;
  const auto width = 800u;
  const auto height = 800u;

  const auto depth_near = 0.0f;
  const auto depth_far = 1.0f;

  mat4 p_mat = perspective<GLfloat>(zxd::fpi4, 1, 1, 1000);
  mat4 v_mat = lookAt(vec3(100, -100, 100), vec3(0), vec3(0, 0, 1));
  mat4 m_mat = mat4(1);
  mat4 w_mat =
    translate(vec3(x, y, depth_near)) *
    scale(vec3(width * 0.5f, height * 0.5f, 0.5 * (depth_far - depth_near))) *
    translate(vec3(1, 1, 1));

  mat4 mv_mat = v_mat * m_mat;
  mat4 vp_mat = p_mat * v_mat;
  mat4 mvp_mat = p_mat * mv_mat;
  mat4 mvpw_mat = w_mat * mvp_mat;

  print_matrix(w_mat, "wnd");
  print_matrix(p_mat, "proj");
  print_matrix(v_mat, "view");
  print_matrix(m_mat, "model");
  print_matrix(mvp_mat, "mvp");

  print_vector(mv_mat * vec4(0, 0, 0, 1), "mv * vec4(0, 0, 0, 1)");
  print_vector(mvp_mat * vec4(0, 0, 0, 1), "mvp * vec4(0, 0, 0, 1)");
  print_vector(mvpw_mat * vec4(0, 0, 0, 1), "mvpw * vec4(0, 0, 0, 1)");
}
