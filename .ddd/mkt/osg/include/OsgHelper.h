#ifndef UFO_OSGHELPER_H
#define UFO_OSGHELPER_H

#include <string>
#include <stack>

#include <osgUtil/RenderStage>
#include <osgUtil/StateGraph>
#include <osgViewer/Renderer>
#include <osgUtil/PrintVisitor>
#include <osgGA/GUIEventHandler>
#include <osgDB/WriteFile>

namespace galaxy
{

std::string to_string( osg::StateSet::RenderBinMode mode );

std::string to_string( osgUtil::RenderBin::SortMode mode );

class RenderPrinter : public osgUtil::RenderBin::DrawCallback
{
public:
    RenderPrinter( std::ostream& out );

    void drawImplementation( osgUtil::RenderBin* bin, osg::RenderInfo& renderInfo,
        osgUtil::RenderLeaf*& previous ) override;

    bool getEnabled() const { return _enabled; }
    void setEnabled( bool v ) { _enabled = v; }

private:
    struct RenderStageNode
    {
        int renderOrder; // -1 : pre , 0 : normal, 1 : post
        int order;
        const osgUtil::RenderStage* stage;
    };

    using RenderBinStack = std::vector<const osgUtil::RenderBin*>;
    using RenderStageStack = std::vector<RenderStageNode>;

    void printRenderStage( const osgUtil::RenderStage* stage );

    void pushRenderStage( int renderOrder, int order, const osgUtil::RenderStage* stage );
    void popRenderStage();

    void pushRenderBin( const osgUtil::RenderBin* bin );
    void popRenderBin();

    void printRenderBin( const osgUtil::RenderBin* bin );

    void printPath();

    template <typename T>
    void printLeaves( const T& leaves ) const
    {
        for ( const auto leaf : leaves )
        {
            auto drawable = leaf->getDrawable();
            if ( drawable )
            {
                _out << "    " << drawable << " \"" << drawable->getName() << "\"\n";
            }
            else
            {
                _out << "0 drawable pointer found, could be a potential bug\n";
            }
        }
    }

    mutable bool _enabled = false;
    std::ostream& _out;
    std::map<const osgUtil::RenderStage*, int> _stageIndents;

    RenderStageStack _stages;
    RenderBinStack _bins;
};

class VerbosePrintVisitor : public osgUtil::PrintVisitor
{
public:
    using PrintVisitor::PrintVisitor;

    void apply( osg::Node& node ) override;
};

class OsgDebugHandler : public osgGA::GUIEventHandler
{
public:
    OsgDebugHandler( osg::Camera* camera );

    virtual bool handle( const osgGA::GUIEventAdapter& ea, osgGA::GUIActionAdapter& aa );

    void setCamera( osg::Camera* v );

private:
    osg::Camera* _camera = 0;
    osg::ref_ptr<RenderPrinter> _renderStagePrinter;
};

} // namespace galaxy
#endif // UFO_OSGHELPER_H
