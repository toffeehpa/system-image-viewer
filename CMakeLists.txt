cmake_minimum_required(VERSION 3.21)
project(system-image-viewer LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick QuickControls2 Widgets)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(system-image-viewer
        src/main.cpp
)

target_include_directories(system-image-viewer PRIVATE src/core)

qt_add_qml_module(system-image-viewer
        URI SystemImageViewer
        VERSION 1.0
        QML_FILES
        qml/Main.qml
        qml/ImageView.qml
        qml/ZoomHud.qml
        qml/Filmstrip.qml
        qml/NormalWindow.qml
        qml/Viewer.qml
        qml/ContextMenu.qml
        SOURCES
        src/core/ImageModel.h
        src/core/ImageModel.cpp
        src/core/FileOps.h
        src/core/FileOps.cpp
        src/core/FileActions.h
        src/core/FileActions.cpp
        src/core/NativeContextMenu.h
        src/core/NativeContextMenu.cpp
        RESOURCES
        qml/assets/test-image.png
        qml/assets/mafuyu.webp
)

target_link_libraries(system-image-viewer PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::Widgets
)

set_target_properties(system-image-viewer PROPERTIES
        WIN32_EXECUTABLE FALSE
)