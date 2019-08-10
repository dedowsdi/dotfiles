cmake_minimum_required(VERSION 3.8)

project(tt VERSION 0.0 LANGUAGES CXX)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake;${CMAKE_MODULE_PATH}")

# Require out-of-source builds
file(TO_CMAKE_PATH "${PROJECT_BINARY_DIR}/CMakeLists.txt" LOC_PATH)
if(EXISTS "${LOC_PATH}")
    message(FATAL_ERROR "You cannot build in a source directory (or any directory with a CMakeLists.txt file). Please make a build subdirectory. Feel free to remove CMakeCache.txt and CMakeFiles.")
endif()

set(DEFAULT_BUILD_TYPE "Release")
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE STRING "Choose the type of build." FORCE)

  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# -isystem ... is used to add auto complete for c++ head in ycm
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  -pthread")

set(SRC
    main.cpp
    )

add_executable(tt ${SRC})

# global cxx version
# set(CMAKE_CXX_STANDARD 14)
# set(CMAKE_CXX_STANDARD_REQUIRED ON)
# set(CMAKE_CXX_EXTENSIONS OFF)

# target cxx version
target_compile_features(tt PUBLIC cxx_std_14)
set_target_properties(tt PROPERTIES CXX_EXTENSIONS OFF)


target_compile_options(tt PRIVATE $<$<AND:$<CONFIG:Debug>,$<CXX_COMPILER_ID:GNU>>:-pthread -gdwarf -g3>)
