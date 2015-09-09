cmake_minimum_required (VERSION 3.0.0)
project (EigenTestProject)

file(DOWNLOAD "https://github.com/FlorianChevassu/APM/archive/master.zip" ${CMAKE_CURRENT_BINARY_DIR}/APM.zip STATUS download_status SHOW_PROGRESS)
list(GET download_status 0 download_status_value)
if(NOT download_status_value EQUAL 0)
  message(FATAL_ERROR "Error while downloading APM.")
else()
  message(STATUS "APM downloaded.")
endif()

set(APM_dir ${CMAKE_CURRENT_BINARY_DIR}/APM)
file(MAKE_DIRECTORY ${APM_dir})


execute_process(COMMAND ${CMAKE_COMMAND} -E tar xfz ${CMAKE_CURRENT_BINARY_DIR}/APM.zip
  WORKING_DIRECTORY ${APM_dir}
RESULT_VARIABLE extract_result)
if(NOT extract_result EQUAL 0)
  message(FATAL_ERROR "Error extracting APM.zip.")
else()
    message(STATUS "APM.zip successfully extracted.")
endif()

include(${CMAKE_CURRENT_BINARY_DIR}/APM/APM-master/APM.cmake)
#force installation of eigen...
set(APM_install_Eigen3 ON CACHE BOOL "")

add_executable(EigenTest EigenTest.cpp)
# an APM module repository is a place (folder, GIT repo, etc.) containing CMake modules to "require" projects.
APM_add_module_repository(moduleRepo FOLDER "${CMAKE_CURRENT_SOURCE_DIR}/../")

# an APM package repository contains all the built libraries and sources.
APM_add_package_repository(packageRepo FOLDER "${CMAKE_CURRENT_BINARY_DIR}/packages/")


require_package(Eigen3 VERSION 3.2.5 TARGETS EigenTest PACKAGE_REPOSITORY packageRepo REQUIRED)
