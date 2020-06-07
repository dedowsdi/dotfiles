#include <app.h>

#include <sstream>

namespace zxd {

const auto width = 800;
const auto height = 800;

class program_name : public program
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

} prg;

class app_tt : public app
{

public:
  void init_info() override;
  void create_scene() override;

  void update() override;

  void display() override;

  void glfw_resize(GLFWwindow *wnd, int w, int h) override;

  void glfw_key(GLFWwindow *wnd, int key, int scancode, int action,
                int mods) override;

  void glfw_mouse_button(GLFWwindow *wnd, int button, int action,
                         int mods) override;

  void glfw_mouse_move(GLFWwindow *wnd, double x, double y) override;
};

void app_tt::init_info()
{
  app::init_info();
  m_info.title = "app_tt :";
  m_info.wnd_width = width;
  m_info.wnd_height = height;
}

void app_tt::create_scene()
{

  prg.init();
}

void app_tt::update() {}

void app_tt::display()
{
  glClear(GL_COLOR_BUFFER_BIT);

  prg.use();

  if(!m_display_help)
    return;

  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  std::stringstream ss;
  ss << "hello";
  m_text.print(ss.str(), 10, m_info.wnd_height - 20);

  glDisable(GL_BLEND);
}

void app_tt::glfw_resize(GLFWwindow *wnd, int w, int h)
{
  app::glfw_resize(wnd, w, h);
  m_text.reshape(m_info.wnd_width, m_info.wnd_height);
}

void app_tt::glfw_key(GLFWwindow *wnd, int key, int scancode, int action,
                      int mods)
{
  if (action == GLFW_PRESS)
  {
    switch (key)
    {
    default:
      break;
    }
  }
  app::glfw_key(wnd, key, scancode, action, mods);
}

void app_tt::glfw_mouse_button(GLFWwindow *wnd, int button, int action,
                               int mods)
{
  app::glfw_mouse_button(wnd, button, action, mods);
}

void app_tt::glfw_mouse_move(GLFWwindow *wnd, double x, double y)
{
  app::glfw_mouse_move(wnd, x, y);
}

}

int main(int argc, char *argv[])
{
  zxd::app_tt app;
  app.run();
}
