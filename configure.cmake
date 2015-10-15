
	IPM_get_subdirectories(${Eigen3_PACKAGE_VERSION_ROOT}/install l_IPM_subdirectory)

	list(LENGTH l_IPM_subdirectory l_IPM_subdirectory_length)
	if(${l_IPM_subdirectory_length} GREATER 1)
		inquire_message(FATAL "${Eigen3_PACKAGE_VERSION_ROOT}/install should only have one subdirectory corresponding to the commit id...")
	endif()


	set(l_IPM_include_dir "${Eigen3_PACKAGE_VERSION_ROOT}/install/${l_IPM_subdirectory}/")
	if(NOT DEFINED Eigen3_TARGETS)
		inquire_message(WARN "Including directory ${l_IPM_include_dir} globally.")
		include_directories(${l_IPM_include_dir})
	else()
		inquire_message(INFO "Including directory ${l_IPM_include_dir} for targets ${Eigen3_TARGETS}.")
		foreach(l_IPM_target ${Eigen3_TARGETS})
			target_include_directories(${l_IPM_target} PUBLIC ${l_IPM_include_dir})
		endforeach(l_IPM_target)
	endif()
