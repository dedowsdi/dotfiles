#include "OsgHelper.h"
#include <osgViewer/Viewer>

namespace galaxy
{

std::string to_string( osg::StateSet::RenderBinMode mode )
{
    switch ( mode )
    {
        case osg::StateSet::INHERIT_RENDERBIN_DETAILS:
            return "INHERIT_RENDERBIN_DETAILS";
        case osg::StateSet::OVERRIDE_PROTECTED_RENDERBIN_DETAILS:
            return "OVERRIDE_PROTECTED_RENDERBIN_DETAILS";
        case osg::StateSet::OVERRIDE_RENDERBIN_DETAILS:
            return "OVERRIDE_RENDERBIN_DETAILS";
        case osg::StateSet::PROTECTED_RENDERBIN_DETAILS:
            return "PROTECTED_RENDERBIN_DETAILS";
        case osg::StateSet::USE_RENDERBIN_DETAILS:
            return "USE_RENDERBIN_DETAILS";
        default:
            throw std::runtime_error( "unknown mode " + std::to_string( mode ) );
    }
}

std::string to_string( osgUtil::RenderBin::SortMode mode )
{
    switch ( mode )
    {
        case osgUtil::RenderBin::SORT_BACK_TO_FRONT:
            return "SORT_BACK_TO_FRONT";
        case osgUtil::RenderBin::SORT_BY_STATE:
            return "SORT_BY_STATE";
        case osgUtil::RenderBin::SORT_BY_STATE_THEN_FRONT_TO_BACK:
            return "SORT_BY_STATE_THEN_FRONT_TO_BACK";
        case osgUtil::RenderBin::SORT_FRONT_TO_BACK:
            return "SORT_FRONT_TO_BACK";
        case osgUtil::RenderBin::TRAVERSAL_ORDER:
            return "TRAVERSAL_ORDER";
        default:
            throw std::runtime_error( "unknown mode " + std::to_string( mode ) );
    }
}

RenderPrinter::RenderPrinter( std::ostream& out ) : _out( out ) {}

void RenderPrinter::drawImplementation(
    osgUtil::RenderBin* bin, osg::RenderInfo& renderInfo, osgUtil::RenderLeaf*& previous )
{
    if ( _enabled )
    {
        auto stage = dynamic_cast<osgUtil::RenderStage*>( bin );
        if ( stage )
        {
            _out << std::string( 60, '-' ) << "\n";
            _out << "Frame " << renderInfo.getState()->getFrameStamp()->getFrameNumber()
                 << "\n";
            pushRenderStage( 0, 0, stage );
            printRenderStage( stage );
            popRenderStage();
        }
    }

    _enabled = false;
    bin->drawImplementation( renderInfo, previous );
}

void RenderPrinter::printRenderStage( const osgUtil::RenderStage* stage )
{
    auto& preStages = stage->getPreRenderList();
    for ( auto& item : preStages )
    {
        pushRenderStage( -1, item.first, item.second );
        printRenderStage( item.second );
        popRenderStage();
    }

    std::cout << std::string( 40, '=' ) << std::endl;
    pushRenderBin( stage );
    printRenderBin( stage );
    popRenderBin();

    auto& postStages = stage->getPostRenderList();
    for ( auto& item : postStages )
    {
        pushRenderStage( 1, item.first, item.second );
        printRenderStage( item.second );
        popRenderStage();
    }
}

void RenderPrinter::pushRenderStage(
    int renderOrder, int order, const osgUtil::RenderStage* stage )
{
    _stages.push_back( {renderOrder, order, stage} );
}

void RenderPrinter::popRenderStage() { _stages.pop_back(); }

void RenderPrinter::pushRenderBin( const osgUtil::RenderBin* bin )
{
    _bins.push_back( bin );
}

void RenderPrinter::popRenderBin() { _bins.pop_back(); }

void RenderPrinter::printRenderBin( const osgUtil::RenderBin* bin )
{
    // print child bins with binNum <0
    auto& bins = bin->getRenderBinList();
    for ( auto it = bins.begin(); it->first < 0 && it != bins.end(); ++it )
    {
        pushRenderBin( it->second );
        printRenderBin( it->second );
        popRenderBin();
    }

    // print stage path, bin path
    std::cout << std::string( 20, '*' ) << std::endl;
    printPath();

    auto& fineGrained = bin->getRenderLeafList();
    if ( !fineGrained.empty() )
    {
        _out << "fine grained :\n";
        printLeaves( fineGrained );
    }

    _out << "coarse grained :\n";
    for ( auto graph : bin->getStateGraphList() )
    {
        _out << "StageGraph : " << graph << "\n";
        printLeaves( graph->_leaves );
    }

    // print child bins with binNum >0
    for ( auto it = bins.begin(); it->first > 0 && it != bins.end(); ++it )
    {
        pushRenderBin( it->second );
        printRenderBin( it->second );
        popRenderBin();
    }
}

void RenderPrinter::printPath()
{
    for ( auto i = 0; i < _stages.size(); ++i )
    {
        auto& stageNode = _stages[i];
        if ( stageNode.renderOrder == 0 )
        {
            _out << ":" << stageNode.stage;
        }
        else
        {
            _out << ( stageNode.renderOrder < 0 ? "<--" : "-->" );
            _out << stageNode.order << "-" << stageNode.stage;
        }

        auto camera = stageNode.stage->getCamera();
        if ( camera && !camera->getName().empty() )
        {
            _out << "(camera : " << camera->getName() << ")";
        }
        _out << "\n";
    }
    _out << "\n";
    std::string binIndent = "    ";

    for ( auto i = 0; i < _bins.size(); ++i )
    {
        auto bin = _bins[i];
        _out << binIndent << bin->getBinNum() << "-" << bin << "("
             << to_string( bin->getSortMode() ) << ")";

        if ( bin->getStateSet() )
        {
            _out << ", StateSet : " << bin->getStateSet();
        }
        _out << "\n";
    }
    _out << "\n";
}

void VerbosePrintVisitor::apply( osg::Node& node )
{
    output() << node.libraryName() << "::" << node.className() << " ( " << &node << " ) "
             << "\"" << node.getName() << "\"";
    auto ss = node.getStateSet();
    if ( ss )
    {
        _out << " StateSet( " << ss;
        if ( ss->getRenderBinMode() != osg::StateSet::INHERIT_RENDERBIN_DETAILS )
        {
            _out << " " << to_string( ss->getRenderBinMode() ) << " " << ss->getBinNumber()
                 << " \"" << ss->getBinName() << "\"";
        }

        _out << " )";
    }
    _out << "\n";
    enter();
    traverse( node );
    leave();
}

OsgDebugHandler::OsgDebugHandler( osg::Camera* camera )
{
    _renderStagePrinter = new RenderPrinter( std::cout );
    setCamera( camera );
}

bool OsgDebugHandler::handle(
    const osgGA::GUIEventAdapter& ea, osgGA::GUIActionAdapter& aa )
{
    switch ( ea.getEventType() )
    {
        case osgGA::GUIEventAdapter::KEYDOWN:
            switch ( ea.getKey() )
            {
                case osgGA::GUIEventAdapter::KEY_F2:
                {
                    OSG_NOTICE << std::string( 60, '-' ) << "\n";
                    auto visitor = new VerbosePrintVisitor( std::cout );
                    _camera->accept( *visitor );
                    break;
                }

                case osgGA::GUIEventAdapter::KEY_F4:
                    osgDB::writeNodeFile( *_camera, "scene.osgt",
                        new osgDB::Options( "WriteImageHint=UseExternal" ) );
                    break;

                case osgGA::GUIEventAdapter::KEY_F3:
                {
                    _renderStagePrinter->setEnabled( true );
                }
                break;

                default:
                    break;
            }
            break;
        default:
            break;
    }
    return false; // return true will stop event
}

void OsgDebugHandler::setCamera( osg::Camera* v )
{
    _camera = v;
    // _camera->setInitialDrawCallback( _renderStagePrinter );
    auto renderer = dynamic_cast<osgViewer::Renderer*>( _camera->getRenderer() );
    if ( renderer )
    {
        renderer->getSceneView( 0 )->getRenderStage()->setDrawCallback(
            _renderStagePrinter );
        renderer->getSceneView( 1 )->getRenderStage()->setDrawCallback(
            _renderStagePrinter );
    }

    // TODO slave cameras?
}

} // namespace galaxy
