#include "app.h"

#include <sstream>

#include <cuboid.h>
#include <common_program.h>

namespace zxd {

const GLint width = 800;
const GLint height = 800;
lightless_program prg;
cuboid cube;
mat4 p_mat;
mat4 v_mat;
mat4 m_mat;

class unused_program : public program
{
public:

protected:

  void attach_shaders()
  {
    attach(GL_VERTEX_SHADER, "shader4/tt.vs.glsl");
    attach(GL_FRAGMENT_SHADER, "shader4/tt.fs.glsl");
  }

  void bind_uniform_locations()
  {

  }

  void bind_attrib_locations()
  {

  }

};

class app_tt : public app {
private:

public:
  void init_info() override;
  void create_scene() override;

  void update() override;

  void display() override;

  void glfw_resize(GLFWwindow *wnd, int w, int h) override;

  void glfw_key(
    GLFWwindow *wnd, int key, int scancode, int action, int mods) override;
  void glfw_mouse_button(GLFWwindow *wnd, int button, int action,
    int mods) override;

  void glfw_mouse_move(GLFWwindow *wnd, double x, double y) override;
};

void app_tt::init_info() {
  app::init_info();
  m_info.title = "app_tt";
  m_info.wnd_width = width;
  m_info.wnd_height = height;
}

void app_tt::create_scene() {

  glEnable(GL_CULL_FACE);

  cube.include_color(true);
  cube.build_mesh();

  prg.with_color = true;
  prg.init();

  p_mat = perspective(fpi4, wnd_aspect(), 0.1f, 1000.0f);
  v_mat = isometric_projection(2);
  set_v_mat(&v_mat);
  m_mat = mat4(1);
}

void app_tt::update() {}

void app_tt::display() {
  glClear(GL_COLOR_BUFFER_BIT);

  prg.use();
  auto mvp_mat = p_mat * v_mat * m_mat;
  glUniformMatrix4fv(prg.ul_mvp_mat, 1, 0, value_ptr(mvp_mat));

  cube.draw();

  if(!m_display_help)
    return;

  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  std::stringstream ss;
  ss << "";
  m_text.print(ss.str(), 10, m_info.wnd_height - 20);
  glDisable(GL_BLEND);
}

void app_tt::glfw_resize(GLFWwindow *wnd, int w, int h) {
  app::glfw_resize(wnd, w, h);
}

void app_tt::glfw_key(
  GLFWwindow *wnd, int key, int scancode, int action, int mods) {
  if (action == GLFW_PRESS) {
    switch (key) {
      default:
        break;
    }
  }
  app::glfw_key(wnd, key, scancode, action, mods);
}

void app_tt::glfw_mouse_button(
  GLFWwindow* wnd, int button, int action, int mods)
{
  app::glfw_mouse_button(wnd, button, action, mods);
}

void app_tt::glfw_mouse_move(GLFWwindow *wnd, double x, double y)
{
  app::glfw_mouse_move(wnd, x, y);
}

}

int main(int argc, char *argv[]) {
  zxd::app_tt app;
  app.run();
}
