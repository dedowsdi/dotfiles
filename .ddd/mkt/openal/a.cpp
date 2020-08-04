#include "a.h"
#include <iostream>
#include <string>
#include <algorithm>
#include <cstring>
#include <thread>
#include <chrono>
#include <iterator>
#include <fstream>
#include <filesystem.hpp>

#include <AL/al.h>
#include <AL/alc.h>
#include <AL/alext.h>
#include <AL/alut.h>
#include "Config.h"

const char* alErrorToString( int error )
{
    switch ( error )
    {
        case AL_NO_ERROR:
            return "AL_NO_ERROR";
        case AL_INVALID_NAME:
            return "AL_INVALID_NAME";
        case AL_INVALID_ENUM:
            return "AL_INVALID_ENUM";
        case AL_INVALID_VALUE:
            return "AL_INVALID_VALUE";
        case AL_INVALID_OPERATION:
            return "AL_INVALID_OPERATION";
        case AL_OUT_OF_MEMORY:
            return "AL_OUT_OF_MEMORY";
        default:
            return "Illegal error enum";
    }
}

const char* alDistanceModelToString( int model )
{
    switch ( model )
    {
        case AL_NONE:
            return "AL_INVERSE_DISTANCE";
        case AL_INVERSE_DISTANCE:
            return "AL_INVERSE_DISTANCE";
        case AL_INVERSE_DISTANCE_CLAMPED:
            return "AL_INVERSE_DISTANCE_CLAMPED";
        case AL_LINEAR_DISTANCE:
            return "AL_LINEAR_DISTANCE";
        case AL_LINEAR_DISTANCE_CLAMPED:
            return "AL_LINEAR_DISTANCE_CLAMPED";
        case AL_EXPONENT_DISTANCE:
            return "AL_EXPONENT_DISTANCE";
        case AL_EXPONENT_DISTANCE_CLAMPED:
            return "AL_EXPONENT_DISTANCE_CLAMPED";
        default:
            return "invalid distance model";
    }
}

#define AL_CHECK_PER_CALL

#ifdef AL_CHECK_PER_CALL

#define AL_CHECK_ERROR                                                         \
    {                                                                          \
        auto error = alGetError();                                             \
        if ( error != AL_NO_ERROR )                                            \
        {                                                                      \
            std::cerr << __FUNCTION__ << ":" << __LINE__                       \
                      << ":OpenAL:" << alErrorToString( error ) << std::endl;  \
        }                                                                      \
    }

#define ALUT_CHECK_ERROR                                                       \
    {                                                                          \
        auto error = alutGetError();                                           \
        if ( error != ALUT_ERROR_NO_ERROR )                                    \
        {                                                                      \
            std::cerr << __FUNCTION__ << ":" << __LINE__                       \
                      << ":alut:" << alutGetErrorString( error ) << std::endl; \
        }                                                                      \
    }

#else

#define AL_CHECK_ERROR
#define ALUT_CHECK_ERROR

#endif /* ifndef AL_CHECK_PER_CALL */

void listAudioDevices( const ALCchar* devices )
{
    if ( !devices || !*devices )
    {
        std::cout << "empty device string!!!" << std::endl;
        return;
    }

    auto device = devices;

    std::cout << "OpenAL audio device list:\n";
    while ( *device )
    {
        std::cout << device << "\n";
        device += ( strlen( device ) + 1 );
    }
    std::cout << std::endl;
}

#define AL_MANAGE_CONTEXT_BY_ALUT 1

bool initOpenAL( int argc, char* argv[] )
{
    auto enumeration = alcIsExtensionPresent( NULL, "ALC_ENUMERATION_EXT" );
    if ( enumeration == AL_FALSE )
    {
        std::cerr << "OpenAL : enumeration extension not available\n"
                  << std::endl;
    }
    else
    {
        listAudioDevices( alcGetString( NULL, ALC_DEVICE_SPECIFIER ) );
    }

    auto defaultDeviceName = alcGetString( NULL, ALC_DEFAULT_DEVICE_SPECIFIER );
    std::cout << "default OpenAL device : " << defaultDeviceName << std::endl;

#if AL_MANAGE_CONTEXT_BY_ALUT
    alutInit( &argc, argv );
    ALUT_CHECK_ERROR

#else
    alutInitWithoutContext( &argc, argv );

    auto device = alcOpenDevice( defaultDeviceName );
    if ( !device )
    {
        std::cerr << "OpenAL unable to open default device\n" << std::endl;
        return false;
    }

    auto context = alcCreateContext( device, NULL );
    if ( !context )
    {
        std::cerr << "OpenAL failed to create context" << std::endl;
    }

    if ( !alcMakeContextCurrent( context ) )
    {
        std::cerr << "OpenAL failed to make default context\n" << std::endl;
        return false;
    }
    AL_CHECK_ERROR;

#endif

    {
        auto context = alcGetCurrentContext();
        auto device = alcGetContextsDevice( context );
        std::cout << "OpenAL open device : "
                  << alcGetString( device, ALC_DEVICE_SPECIFIER ) << std::endl;

        // defaults to AL_INVERS_DISTANCE_CAMPED (IASIG I3DL2)
        // rd = AL_REFERENCE_DISTANCE (per source, defaults to 1),
        // rf = AL_ROLLOFF_FACTOR (per source, defaults to 1),
        // rm = AL_MAX_DISTANCE (per source, defaults to MAX_FLOAT)
        // distance = clamp(distance, rd, rm)
        // gain = rd / (rd + rf * (distance - rd))
        std::cout << "OpenAL distance model : "
                  << alDistanceModelToString(
                         alGetInteger( AL_DISTANCE_MODEL ) )
                  << std::endl;
    }
    std::cout << "------------" << std::endl;

    return true;
}

void closeOpenAL()
{
#if AL_MANAGE_CONTEXT_BY_ALUT
    alutExit();
    ALUT_CHECK_ERROR;
#else
    auto context = alcGetCurrentContext();
    auto device = alcGetContextsDevice( context );
    alcMakeContextCurrent( NULL );
    alcDestroyContext( context );
    alcCloseDevice( device );
#endif
}

int main( int argc, char* argv[] )
{
    // even alut require al context
    {
        ALsizei size;
        ALfloat frequence;
        ALenum format;
        auto data = alutLoadMemoryFromFile("data/sound/hit.wav", &format, &size, &frequence);
        ALUT_CHECK_ERROR;
        std::cout << data << std::endl;
    }

    initOpenAL( argc, argv );

    {
        ALsizei size;
        ALfloat frequence;
        ALenum format;
        auto data = alutLoadMemoryFromFile("data/sound/hit.wav", &format, &size, &frequence);
        ALUT_CHECK_ERROR;
        std::cout << data << std::endl;
    }


    std::string cfg = "data/al.cfg";

    // Source related effects have to be applied before listener related effects
    // unless the output is invariant to any collapse or reversal of order?
    unsigned source;
    alGenSources( 1, &source );

    // read hello world buffer
    unsigned buffer;
    alGenBuffers( 1, &buffer );
    AL_CHECK_ERROR;

    ALvoid* data;
    ALsizei size;
    ALfloat frequence;
    ALenum format;
    // ALboolean loop = AL_FALSE;

    data = alutLoadMemoryHelloWorld( &format, &size, &frequence );
    ALUT_CHECK_ERROR;

    alBufferData( buffer, format, data, size, frequence );
    AL_CHECK_ERROR;

    alSourcei( source, AL_BUFFER, buffer );
    AL_CHECK_ERROR;

    using Vec3 = std::array<float, 3>;
    using Vec6 = std::array<float, 6>;
    Vec3 zero3 = {0, 0, 0};
    Vec6 zero6 = {0, 0, 0, 0, 0, 0};

    auto lastModifiedTime = 0;
    namespace fs = boost::filesystem;
    while ( true )
    {
        try
        {
            std::this_thread::sleep_for( std::chrono::milliseconds( 17 ) );
            auto t = fs::last_write_time( cfg );
            if (t == lastModifiedTime)
            {
                continue;
            }

            sgc.readSetting( cfg );
            lastModifiedTime = t;

            // configure source
            {
                auto position = sgc.get<Vec3>("source.position", zero3);
                auto velocity = sgc.get<Vec3>("source.velocity", zero3);
                auto gain = sgc.get<float>("source.gain", 1);
                auto relative = sgc.get<bool>("source.relative", false);
                auto loop = sgc.get<bool>("source.loop", false);
                auto minGain = sgc.get<float>("source.minGain", 0);
                auto maxGain = sgc.get<float>("source.maxGain", 1.0f);
                auto referenceDistance = sgc.get<float>("source.referenceDistance", 1.0f);
                auto rolloffFactor = sgc.get<float>("source.rolloffFactor", 1.0f);
                auto maxDistance = sgc.get<float>("source.maxDistance", 1000000.0f);
                auto pitch = sgc.get<float>("source.pitch", 1.0f);
                auto direction = sgc.get<Vec3>("source.direction", zero3);
                auto coneInnerAngle = sgc.get<float>("source.coneInnerAngle", 360);
                auto coneOuterAngle =
                    sgc.get<float>( "source.coneOuterAngle", 360 );
                auto coneOuterGain =
                    sgc.get<float>( "source.coneOuterGain", 0 );

                alSourcefv( source, AL_POSITION, &position.front() );
                AL_CHECK_ERROR;
                alSourcefv( source, AL_VELOCITY, &velocity.front() );
                AL_CHECK_ERROR;
                alSourcef( source, AL_GAIN, gain );
                AL_CHECK_ERROR;
                alSourcei( source, AL_SOURCE_RELATIVE, relative );
                AL_CHECK_ERROR;
                alSourcei( source, AL_LOOPING, loop );
                AL_CHECK_ERROR;
                alSourcef( source, AL_MIN_GAIN, minGain );
                AL_CHECK_ERROR;
                alSourcef( source, AL_MAX_GAIN, maxGain );
                AL_CHECK_ERROR;
                alSourcef( source, AL_REFERENCE_DISTANCE, referenceDistance );
                AL_CHECK_ERROR;
                alSourcef( source, AL_ROLLOFF_FACTOR, rolloffFactor );
                AL_CHECK_ERROR;
                alSourcef( source, AL_MAX_DISTANCE, maxDistance );
                AL_CHECK_ERROR;
                alSourcef( source, AL_PITCH, pitch );
                AL_CHECK_ERROR;
                alSourcefv( source, AL_DIRECTION, &direction.front() );
                AL_CHECK_ERROR;
                alSourcef( source, AL_CONE_INNER_ANGLE, coneInnerAngle );
                AL_CHECK_ERROR;
                alSourcef( source, AL_CONE_OUTER_ANGLE, coneOuterAngle );
                AL_CHECK_ERROR;
                alSourcef( source, AL_CONE_OUTER_GAIN, coneOuterGain );
                AL_CHECK_ERROR;
            }

            alSourcePlay( source );
            AL_CHECK_ERROR;

            // configure listener
            {
                auto position = sgc.get<Vec3>("listener.position", zero3);
                auto velocity = sgc.get<Vec3>("listener.velocity", zero3);
                auto gain = sgc.get<float>("listener.gain", 1);
                auto orientation = sgc.get<Vec6>("listener.orientation", zero6);
                alListenerfv(AL_POSITION, &position.front());
                AL_CHECK_ERROR;
                alListenerfv(AL_VELOCITY, &velocity.front());
                AL_CHECK_ERROR;
                alListenerf(AL_GAIN, gain);
                AL_CHECK_ERROR;
                alListenerfv(AL_ORIENTATION, &orientation.front());
                AL_CHECK_ERROR;
            }

        }
        catch ( const std::exception& e )
        {
            std::cerr << e.what() << std::endl;
        }
    }

    alDeleteSources( 1, &source );
    AL_CHECK_ERROR;
    alDeleteBuffers( 1, &buffer );
    AL_CHECK_ERROR;

    closeOpenAL();

    std::cout << "done" << std::endl;

    return 0;
}
