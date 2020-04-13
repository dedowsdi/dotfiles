#include <osgViewer/Viewer>
#include <osgViewer/ViewerEventHandlers>
#include <osgGA/StateSetManipulator>
#include <osg/ShapeDrawable>
#include <OsgHelper.h>
#include <OsgFactory.h>

osg::Node* createCube()
{
    auto leaf = new osg::Geode;
    auto box = new osg::Box(osg::Vec3(), 2, 2, 2);
    auto drawable = new osg::ShapeDrawable(box);
    leaf->addDrawable(drawable);
    return leaf;
}

int main( int argc, char* argv[] )
{
    auto root = new osg::Group;
    auto rootSS = root->getOrCreateStateSet();

    auto cube = createCube();
    root->addChild(cube);

    osgViewer::Viewer viewer;
    viewer.setSceneData( root );
    viewer.addEventHandler( new osgViewer::StatsHandler );
    viewer.addEventHandler( new osgGA::StateSetManipulator( rootSS ) );
    viewer.addEventHandler( new galaxy::OsgDebugHandler( viewer.getCamera() ) );

    return viewer.run();
}
