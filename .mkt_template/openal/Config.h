#ifndef UFO_CONFIG_H
#define UFO_CONFIG_H

#include <string>
#include <map>

namespace dedowsdi
{

#define sgc ::dedowsdi::Config::instance()

class Config
{
public:
    Config( const Config& ) = delete;
    Config& operator=( const Config& ) = delete;

    static Config& instance()
    {
        static Config instance;
        return instance;
    }

    void clear();

    void readSetting(const std::string& filepath);

    template <typename T>
    T get( const std::string& key, const T& defaultValue );

private:
    Config() = default;
    ~Config() = default;

    using ConfigMap = std::map<std::string, std::string>;
    ConfigMap _dict;
};

} // namespace galaxy

#endif // UFO_CONFIG_H
