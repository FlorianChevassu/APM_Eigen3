cmake_minimum_required (VERSION 3.0.0)
project (EigenTestProject)

include(${CMAKE_CURRENT_LIST_DIR}/../../Inquire/Inquire.cmake)
#force installation of eigen...
set(INSTALL_Eigen3 ON CACHE BOOL "")

add_executable(EigenTest EigenTest.cpp)
# an IPM module repository is a place (folder, GIT repo, etc.) containing CMake modules to "require" projects.
inquire_add_module_repository(moduleRepo FOLDER "${CMAKE_CURRENT_SOURCE_DIR}/../../")

# an IPM package repository contains all the built libraries and sources.
inquire_add_package_repository(packageRepo FOLDER "${CMAKE_CURRENT_BINARY_DIR}/packages/")


require_package(Eigen3 VERSION 3.2.5 TARGETS EigenTest PACKAGE_REPOSITORY packageRepo REQUIRED)
