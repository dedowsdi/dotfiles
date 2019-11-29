add_library(mylib src/mylib.cpp)
target_include_directories(mylib PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include/mylib>
    )

# create version file
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    mylibConfigVersion.cmake
    VERSION ${PACKAGE_VERSION}
    COMPATIBILITY AnyNewerVersion
    )

# create config file
configure_file(mylibConfig.cmake.in mylibConfig.cmake @ONLY)

# export build tree target, it's included in config file
export(TARGETS mylib NAMESPACE test:: FILE mylibTargets.cmake)

# add to user package registry
export(PACKAGE mylib)

# install lib, export install tree target
install(TARGETS mylib
    EXPORT mylibTargets
    # INCLUDES DESTINATION include/mylibb
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    )

install(DIRECTORY include/ DESTINATION include/mylib)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/mylibConfig.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/mylibConfigVersion.cmake
        DESTINATION lib/mylib/cmake)

# install install tree target
install(EXPORT mylibTargets NAMESPACE test:: DESTINATION lib/mylib/cmake)
