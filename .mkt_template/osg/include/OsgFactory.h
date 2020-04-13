#ifndef UFO_OSGFACTORY_H
#define UFO_OSGFACTORY_H

// Create util for osg, don't include large head files.
#include <functional>
#include <string>
#include <vector>
#include <osg/Vec2>
#include <osg/Vec3>
#include <osg/Vec4>

// forward declare {{{1
namespace osg
{
class Geometry;
class Geode;
class Node;
class Program;
class Camera;
class Texture2D;
class StateSet;
class FrameBufferObject;
class Drawable;
class RenderInfo;
class Quat;
class Object;
class Callback;
class Vec3d;
class MatrixTransform;
class AnimationPath;

class Matrixf;
class Matrixd;
#ifdef OSG_USE_FLOAT_MATRIX
typedef Matrixf Matrix;
#else
typedef Matrixd Matrix;
#endif

template <typename VT>
class BoundingBoxImpl;

typedef BoundingBoxImpl<Vec3f> BoundingBoxf;
typedef BoundingBoxImpl<Vec3d> BoundingBoxd;

#ifdef OSG_USE_FLOAT_BOUNDINGBOX
typedef BoundingBoxf BoundingBox;
#else
typedef BoundingBoxd BoundingBox;
#endif

}  // namespace osg

namespace osgAnimation
{
class Skeleton;
class Bone;
class Action;
class ActionVisitor;

template <typename T>
class TemplateKeyframe;

template <typename T>
class TemplateKeyframeContainer;

typedef TemplateKeyframe<osg::Quat> QuatKeyframe;
typedef TemplateKeyframeContainer<osg::Quat> QuatKeyframeContainer;
}  // namespace osgAnimation

namespace osgWidget
{
class Widget;
}

// create*  Create something, caller is in charge of the memory.
// get*     Get something, mostly a function local static.
// add*     Add something.
// set*     Change something.
// draw*    Mostly for debug purpose, add some drawables with a custom visitor.
namespace osgf
{

// Node {{{1

// culling is disabled for the quad.
osg::Geometry* getNdcQuad();

osg::Geode* createNdcQuadLeaf();

// create sphere, move to pos
osg::MatrixTransform* createSphere( const osg::Vec3& pos, float radius );

// You have stacks+1 rows of vertices, each row has slices+1 cols, this function
// create triangle strip elements as adbecf... or dadbfc... if reversed:
//  a b c ...
//  d e f ...
template <typename T>
void addGridElements(
    osg::Geometry& geom, int stacks, int slices, int offset = 0, bool reverse = false );

// texcoord0 : texcoord of 1st vertex in 1st stack
// texcoord1 : texcoord of last vertex in last stack
template <typename T>
void addGridTexcoords( T& texcoords, int stacks, int slices,
    const osg::Vec2& texcoord0 = osg::Vec2( 0, 1 ),
    const osg::Vec2& texcoord1 = osg::Vec2( 1, 0 ) );

// Only used for debug purpose. All axes created by this function share a
// function local static StateSet.
// StateSet:
//      GL_DEPTH_TEST  0
//      GL_LIGHTING 0
//      LineWidth
osg::Geometry* createAxes( float size = 1.0f, float lineWidth = 1.5f );

osg::Geometry* createLines( const std::vector<osg::Vec3>& lines );

osg::Geometry* createTorus( float innerRadius, float outerRadius, int sides, int rings );

using CallbackFunction = std::function<void( osg::Object*, osg::Object* )>;

osg::Callback* createCallback( CallbackFunction callback );

// execute call back after certain time, once only, removed immediately after that.
osg::Callback* createTimerUpdateCallback( double time, CallbackFunction callback );

using ComputeBoundingBoxCallbackFunction =
    std::function<osg::BoundingBox( const osg::Drawable& )>;
void* createComputeBoundingBoxCallback( ComputeBoundingBoxCallbackFunction func );

void addConstantComputeBoundingBoxCallback( osg::Drawable& d, const osg::BoundingBox& bb );

void addInvalidComputeBoundingBoxCallback( osg::Drawable& d );

// Program {{{1

osg::Program* createProgram( const std::string& vertFile, const std::string& fragFile );

osg::Program* createProgram( const std::string& vertFile, const std::string& geomFile,
    const std::string& fragFile, int inputType, int outputType, int maxVertices );

// Camera {{{1

// 0 clear mask.
osg::Camera* createPrerenderCamera( int x, int y, int width, int height );

// 0 clear mask, pre render.
osg::Camera* createRttCamera( int x, int y, int width, int height, int implementation );

// 0 clear mask, pre render, framebufferobject, no depth test.
osg::Camera* createFilterCamera( int x, int y, int width, int height );

// 0 clear mask, absolute, identity view.
osg::Camera* createOrthoCamera( double left, double right, double bottom, double top,
    double near = -1, double far = 1 );

// Fbo {{{1

// tex0 must not be empty
osg::FrameBufferObject* addFboRtt( osg::StateSet& ss, osg::Texture2D* tex0,
    osg::Texture2D* tex1 = 0, osg::Texture2D* tex2 = 0 );

using DrawableDrawFunc = std::function<void( osg::RenderInfo&, const osg::Drawable* )>;
osg::Drawable* createDrawable( DrawableDrawFunc func );

osg::Drawable* createClearDrawable(
    int mask, const osg::Vec4& clearColor = osg::Vec4( 0, 0, 0, 1 ), float depth = 1.0f );

// Texture {{{1

osg::Texture2D* createTexture(
    int internalFormat, int width, int height, int minFilter, int magFilter );

// tex is not stored. Use texture width height as copy width height if they are
// 0.
osg::Drawable* createCopyTex2DDrawable( osg::Texture2D* tex, int xoffset = 0,
    int yoffset = 0, int x = 0, int y = 0, int width = 0, int height = 0 );

osg::Texture2D* createChessTexture( int width, int height, int gridWidth, int gridHeight,
    const osg::Vec4& black = osg::Vec4( 0, 0, 0, 1 ),
    const osg::Vec4& white = osg::Vec4( 1, 1, 1, 1 ) );

// Rig {{{1

// create bone, setup initial skeleton matrix transform and stacked animation transform, 3
// bit masks represent translation, rotation, scale.
osgAnimation::Bone* createBone( const std::string& name, const osg::Matrix& m,
    bool createSkeletonTransform = true, int animMask = 0b010 );

// 0 0.25pi 0.5pi -> 0 -0.25pi -0.5pi
osgAnimation::QuatKeyframeContainer* createMirrorQuatKeyframes(
    const osgAnimation::QuatKeyframeContainer& ping );

void drawSkeleton( osgAnimation::Skeleton* skeleton, float axisSize );

// Animation {{{1

void addControlPoints( osg::AnimationPath& path, int steps, double time0, double time1,
    const osg::Matrix& m0, const osg::Matrix& m1, bool addStartControlPoint = 1 );

template <typename Element>
void addLinearKeyFrames( osgAnimation::TemplateKeyframeContainer<Element>& container,
    int steps, float time0, float time1, const Element& e0, const Element& e1,
    bool addStartFrame = 1 );

// Use this function if you want to slerp between quat with angles no lesser
// than 2pi.
void addLinearKeyFrames( osgAnimation::QuatKeyframeContainer& container, int steps,
    float time0, float time1, float angle0, float angle1, const osg::Vec3& axis,
    bool addStartFrame = 1 );

using AnimationActionCallbackFunc =
    std::function<void( osgAnimation::Action*, osgAnimation::ActionVisitor* )>;
void* createAnimationActionCallback( AnimationActionCallbackFunc func );

}  // namespace osgf

// vim:set foldmethod=marker:
#endif  // UFO_OSGFACTORY_H
