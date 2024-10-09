cmake_minimum_required(VERSION 3.10)

# Set the project name
project(GahoodPortfolioServer)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(SOURCE_DIR ${CMAKE_SOURCE_DIR}/src)
set(ASSETS_DIR ${CMAKE_SOURCE_DIR}/assets)
set(BUILD_ASSETS_DIR ${CMAKE_BINARY_DIR}/assets)

# set(BOX2D_BUILD_UNIT_TESTS OFF CACHE BOOL "Stop Box2d Unit Tests" FORCE)
# set(BOX2D_BUILD_TESTBED OFF CACHE BOOL "Stop Box2d Test Bed" FORCE)

add_subdirectory(third-party/enet)
# add_subdirectory(third-party/box2d)
# add_subdirectory(third-party/GahoodSON)

include_directories(include)
file(GLOB_RECURSE SOURCES "${SOURCE_DIR}/*.cpp")

# Add the executable for your main application
add_executable(GahoodPortfolioServer ${SOURCES})

# Uncomment if assets are added
# add_custom_target(copy_assets ALL
#     COMMAND ${CMAKE_COMMAND} -E copy_directory
#     ${ASSETS_DIR} ${BUILD_ASSETS_DIR}
# )
# add_dependencies(GahoodPortfolioServer copy_assets)

target_include_directories(GahoodPortfolioServer PRIVATE third-party/enet/include)
# target_include_directories(GahoodPortfolioServer PRIVATE third-party/box2d/include)
# target_include_directories(GahoodPortfolioServer PRIVATE third-party/GahoodSON/include)

target_link_libraries(GahoodPortfolioServer PRIVATE enet)
# target_link_libraries(GahoodPortfolioServer PRIVATE box2d)
# target_link_libraries(GahoodPortfolioServer PRIVATE GahoodSON)
