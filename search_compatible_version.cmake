set(Eigen3_COMPATIBLE_VERSION_FOUND FALSE)


	IPM_get_subdirectories(${Eigen3_PACKAGE_ROOT} l_IPM_version_dirs)

	#try to find a matching version
	foreach(l_IPM_version_dir ${l_IPM_version_dirs})
		set(l_IPM_version_compatible FALSE)
		# first check that the project has been installed. If so, check version compatibility.
		#TODO add path to test file
		if(EXISTS ${Eigen3_PACKAGE_ROOT}/${l_IPM_version_dir}/install/)
			if(${l_IPM_version_dir} VERSION_EQUAL ${Eigen3_VERSION})
				set(Eigen3_COMPATIBLE_VERSION_FOUND TRUE)
				set(Eigen3_VERSION_ROOT ${Eigen3_PACKAGE_ROOT}/${l_IPM_version_dir})
				break()
			else()
				#we assume that greater versions are backward compatible
				if(${l_IPM_version_dir} VERSION_GREATER ${Eigen3_VERSION} AND NOT ${l_IPM_get_compatible_package_version_root_EXACT})
					set(Eigen3_COMPATIBLE_VERSION_FOUND TRUE)
					set(Eigen3_VERSION_ROOT ${Eigen3_PACKAGE_ROOT}/${l_IPM_version_dir})
					break()
				endif()
			endif()
		endif()
	endforeach()

if(NOT ${Eigen3_COMPATIBLE_VERSION_FOUND})
  inquire_message(INFO "No compatible version of Eigen3 found.")
endif()
