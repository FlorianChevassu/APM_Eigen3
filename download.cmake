inquire_message(INFO "Triggering installation of Eigen3 in version ${Eigen3_VERSION}... ")

string(REPLACE "." "_" l_IPM_underscore_version ${Eigen3_VERSION})
set(l_IPM_EigenLocation https://bitbucket.org/eigen/eigen/get/${Eigen3_VERSION}.tar.bz2)

file(MAKE_DIRECTORY ${Eigen3_PACKAGE_ROOT}/${Eigen3_VERSION}/download/)

if(NOT EXISTS ${Eigen3_PACKAGE_ROOT}/${Eigen3_VERSION}/download/${Eigen3_VERSION}.tar.bz2)
  file(DOWNLOAD ${l_IPM_EigenLocation} ${Eigen3_PACKAGE_ROOT}/${Eigen3_VERSION}/download/${Eigen3_VERSION}.tar.bz2
    STATUS l_IPM_download_result
    SHOW_PROGRESS)

  list(GET l_IPM_download_result 0 l_IPM_download_result_code)

  if(NOT l_IPM_download_result_code EQUAL 0)
    inquire_message(FATAL "Unable to download Eigen.")
  endif()
else()
  inquire_message(DEBUG "File ${Eigen3_PACKAGE_ROOT}/${Eigen3_VERSION}/download/${Eigen3_VERSION}.tar.bz2 already exist.")
endif()

file(MAKE_DIRECTORY ${Eigen3_PACKAGE_ROOT}/${Eigen3_VERSION}/install/)

execute_process(COMMAND ${CMAKE_COMMAND} -E tar xzf ${Eigen3_PACKAGE_ROOT}/${Eigen3_VERSION}/download/${Eigen3_VERSION}.tar.bz2 WORKING_DIRECTORY ${Eigen3_PACKAGE_ROOT}/${Eigen3_VERSION}/install RESULT_VARIABLE l_IPM_extract_result)

#TODO add error output from OUTPUT_VARIABLE, ERROR_VARIABLE
if(NOT l_IPM_extract_result EQUAL 0)
  inquire_message(FATAL "Unable to extract Eigen.")
endif()

set(Eigen3_PACKAGE_VERSION_ROOT ${Eigen3_PACKAGE_ROOT}/${Eigen3_VERSION})
