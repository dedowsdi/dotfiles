cmake_minimum_required(VERSION 2.8.12)
project(__PROJECT__)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake;${CMAKE_MODULE_PATH}")

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DDEBUG -D_DEBUG"  )

if( CMAKE_BUILD_TYPE STREQUAL ""  )
	set( CMAKE_BUILD_TYPE Debug CACHE STRING "One of: Debug Release
	RelWithDebInfo MinSizeRel." FORCE  )
endif()

#flag
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -pthread -Wall -Wno-unused-local-typedef -Wno-overloaded-virtual -Wno-inconsistent-missing-override -Wno-switch-bool -Wno-int-to-void-pointer-cast -Wno-unused-function")

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

add_direct(./ __UC_PROJECT___SRC)

add_executable(__PROJECT__ ${__UC_PROJECT___SRC}  )
