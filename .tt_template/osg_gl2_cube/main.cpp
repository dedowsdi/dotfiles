#include <iostream>
#include <string>
#include <vector>
#include <list>
#include <map>
#include <algorithm>
#include <iomanip>
#include <osgViewer/Viewer>
#include <osgDB/ReadFile>
#include <osg/Shader>
#include <osg/Program>

void add_quad(osg::DrawElementsUInt& indices, GLuint v0, GLuint v1, GLuint v2, GLuint v3)
{
  indices.push_back(v0);
  indices.push_back(v1);
  indices.push_back(v2);

  indices.push_back(v0);
  indices.push_back(v2);
  indices.push_back(v3);
}

osg::Node* create_cube()
{
  auto geom = new osg::Geometry();
  auto vertices = new osg::Vec3Array(osg::Array::BIND_PER_VERTEX);
  vertices->reserve(8);

  // top face vertices (ccw)
  vertices->push_back(osg::Vec3(  1,  1,  1));
  vertices->push_back(osg::Vec3( -1,  1,  1));
  vertices->push_back(osg::Vec3( -1, -1,  1));
  vertices->push_back(osg::Vec3(  1, -1,  1));

  // bottom face vertices (cw)
  vertices->push_back(osg::Vec3(  1, -1, -1));
  vertices->push_back(osg::Vec3( -1, -1, -1));
  vertices->push_back(osg::Vec3( -1,  1, -1));
  vertices->push_back(osg::Vec3(  1,  1, -1));

  auto colors = new osg::Vec3Array(osg::Array::BIND_PER_VERTEX);
  colors->reserve(8);
  colors->push_back(osg::Vec3(1, 0, 0));
  colors->push_back(osg::Vec3(0, 1, 0));
  colors->push_back(osg::Vec3(0, 0, 1));
  colors->push_back(osg::Vec3(1, 1, 0));
  colors->push_back(osg::Vec3(1, 0, 1));
  colors->push_back(osg::Vec3(0, 1, 1));
  colors->push_back(osg::Vec3(0, 0, 0));
  colors->push_back(osg::Vec3(1, 1, 1));

  geom->setVertexArray(vertices);
  geom->setColorArray(colors);

  auto elements = new osg::DrawElementsUInt(GL_TRIANGLES, 36, 0);
  elements->reserve(36);
  add_quad(*elements, 0, 1, 2, 3); // up
  add_quad(*elements, 4, 5, 6, 7); // down
  add_quad(*elements, 2, 5, 4, 3); // front
  add_quad(*elements, 0, 7, 6, 1); // back
  add_quad(*elements, 4, 7, 0, 3); // right
  add_quad(*elements, 2, 1, 6, 5); // left
  geom->addPrimitiveSet(elements);

  auto leaf = new osg::Geode;
  leaf->addDrawable(geom);

  return leaf;
}

int main(int argc, char *argv[])
{
  osgViewer::Viewer viewer;
  viewer.setSceneData(create_cube());
  viewer.setLightingMode(osg::View::NO_LIGHT);

  return viewer.run();
}
