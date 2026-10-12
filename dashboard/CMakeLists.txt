cmake_minimum_required(VERSION 3.20)

project(EnvDash LANGUAGES CXX VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)


find_package(Qt6Core REQUIRED)
find_package(Qt6Widgets REQUIRED)
find_package(Qt6Network REQUIRED)
find_package(Qt6Concurrent REQUIRED)
find_package(Qt6Qml REQUIRED)
find_package(Qt6Quick REQUIRED)
find_package(Qt6Charts REQUIRED)


add_subdirectory(src)
