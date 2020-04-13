#include "Config.h"

#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>

namespace dedowsdi
{

void Config::clear() {}

void Config::readSetting(const std::string& filepath)
{
    _dict.clear();

    std::ifstream ifs( filepath );
    std::string line;

    while ( std::getline( ifs, line ) )
    {
        std::string key;
        std::istringstream iss( line );
        iss >> key;

        if ( key.empty() || key.front() == '#' ) continue;

        std::string value;

        if ( line.size() > key.size() )
        {
            value = line.substr( line.find_first_not_of( " \t", key.size() ) );
        }

        if ( value.empty() )
        {
            std::cerr << "missing value for key : " << key << "\n";
            continue;
        }

        _dict.insert( std::make_pair( key, value ) );
    }
}

using Vec3 = std::array<float, 3>;
using Vec6 = std::array<float, 6>;

template <std::array<float, 1>::size_type N>
inline std::istream& operator>>( std::istream& input, std::array<float, N>& vec)
{
    for (auto i = 0u; i < N; ++i)
    {
        input >> vec[i];
    }
    return input;
}

template <typename T>
T Config::get( const std::string& key, const T& defaultValue )
{
    auto iter = _dict.find( key );
    if ( iter == _dict.end() )
    {
        std::cerr << key << " not found." << std::endl;
        return defaultValue;
    }

    T t;
    std::istringstream iss( iter->second );
    iss >> t;

    if ( !iss )
    {
        std::cerr << "Failed to convert key : " << key << "\n";
        return defaultValue;
    }

    return t;
}

#define INSTANTIATE_get( T )                                                   \
    template T Config::get( const std::string& key, const T& defaultValue );


INSTANTIATE_get( bool );
INSTANTIATE_get( char );
INSTANTIATE_get( short );
INSTANTIATE_get( int );
INSTANTIATE_get( unsigned char );
INSTANTIATE_get( unsigned short );
INSTANTIATE_get( unsigned );
INSTANTIATE_get( float );
INSTANTIATE_get( double );
INSTANTIATE_get( std::string );
INSTANTIATE_get( Vec3 );
INSTANTIATE_get( Vec6 );

} // namespace dedowsdi
