function(check_package_compatibility a_IPM_result)
	#This call is useless as we do not handle any argument. However, it could be if we check compiler compatibility.
	#IPM_check_package_compatibility_parse_arguments(l_IPM_check_package_compatibility ${ARGN})
  set(${a_IPM_result} TRUE PARENT_SCOPE)
endfunction()

function(get_compatible_package_version_root a_IPM_package_root a_IPM_version a_IPM_result)
	IPM_get_compatible_package_version_root_parse_arguments(l_IPM_get_compatible_package_version_root ${ARGN})
	IPM_get_subdirectories(${a_IPM_package_root} l_IPM_version_dirs)

	#try to find a matching version
	foreach(l_IPM_version_dir ${l_IPM_version_dirs})
		set(l_IPM_version_compatible FALSE)
		# first check that the project has been installed. If so, check version compatibility.
		#TODO add path to test file
		if(EXISTS ${a_IPM_package_root}/${l_IPM_version_dir}/install/)
			if(${l_IPM_version_dir} VERSION_EQUAL ${a_IPM_version})
				set(l_IPM_version_compatible TRUE)
				set(${a_IPM_result} ${a_IPM_package_root}/${l_IPM_version_dir} PARENT_SCOPE)
				break()
			else()
				#we assume that greater versions are backward compatible
				if(${l_IPM_version_dir} VERSION_GREATER ${a_IPM_version} AND NOT ${l_IPM_get_compatible_package_version_root_EXACT})
					set(l_IPM_version_compatible TRUE)
					set(${a_IPM_result} ${a_IPM_package_root}/${l_IPM_version_dir} PARENT_SCOPE)
					break()
				endif()
			endif()
		endif()
	endforeach()
endfunction()

function(download_package_version a_IPM_package_root a_IPM_result a_IPM_version)
	#construct the link to Eigen3 archive
	string(REPLACE "." "_" l_IPM_underscore_version ${a_IPM_version})
	set(l_IPM_EigenLocation https://bitbucket.org/eigen/eigen/get/${a_IPM_version}.tar.bz2)

	file(MAKE_DIRECTORY ${a_IPM_package_root}/${a_IPM_version}/download/)

	if(NOT EXISTS ${a_IPM_package_root}/${a_IPM_version}/download/${a_IPM_version}.tar.bz2)
		file(DOWNLOAD ${l_IPM_EigenLocation} ${a_IPM_package_root}/${a_IPM_version}/download/${a_IPM_version}.tar.bz2
			STATUS l_IPM_download_result
			SHOW_PROGRESS)


		list(GET l_IPM_download_result 0 l_IPM_download_result_code)

		if(NOT l_IPM_download_result_code EQUAL 0)
			inquire_message(FATAL "Unable to download Eigen.")
		endif()
	else()
		inquire_message(INFO "File ${a_IPM_package_root}/${a_IPM_version}/download/${a_IPM_version}.tar.bz2 already exist.")
	endif()

	file(MAKE_DIRECTORY ${a_IPM_package_root}/${a_IPM_version}/install/)

	execute_process(COMMAND ${CMAKE_COMMAND} -E tar xzf ${a_IPM_package_root}/${a_IPM_version}/download/${a_IPM_version}.tar.bz2 WORKING_DIRECTORY ${a_IPM_package_root}/${a_IPM_version}/install RESULT_VARIABLE l_IPM_extract_result)

	#TODO add error output from OUTPUT_VARIABLE, ERROR_VARIABLE
	if(NOT l_IPM_extract_result EQUAL 0)
		inquire_message(FATAL "Unable to extract Eigen.")
	endif()

	set(${a_IPM_result} ${a_IPM_package_root}/${a_IPM_version} PARENT_SCOPE)
endfunction()

function(package_version_need_compilation a_IPM_package_version_root a_IPM_result)
	#This call is useless as we do not handle COMPONENTS in Eigen. However, it could be if we check compiler compatibility.
	#IPM_package_version_need_compilation_parse_arguments(l_IPM_package_version_need_compilation ${ARGN})

	#Eigen is header only. Hence no compilation is needed.
	set(${a_IPM_result} FALSE PARENT_SCOPE)
endfunction()

function(configure_package_version a_IPM_package_version_root)
	IPM_configure_package_version_parse_arguments(l_IPM_configure_package_version ${ARGN})

	IPM_get_subdirectories(${a_IPM_package_version_root}/install l_IPM_subdirectory)

	list(LENGTH l_IPM_subdirectory l_IPM_subdirectory_length)
	if(${l_IPM_subdirectory_length} GREATER 1)
		inquire_message(FATAL "${a_IPM_package_version_root}/install should only have one subdirectory corresponding to the commit id...")
	endif()


	set(l_IPM_include_dir "${a_IPM_package_version_root}/install/${l_IPM_subdirectory}/")
	if(NOT DEFINED l_IPM_configure_package_version_TARGETS)
		inquire_message(WARN "Including directory ${l_IPM_include_dir} globally.")
		include_directories(${l_IPM_include_dir})
	else()
		inquire_message(INFO "Including directory ${l_IPM_include_dir} for targets ${l_IPM_configure_package_version_TARGETS}.")
		foreach(l_IPM_target ${l_IPM_configure_package_version_TARGETS})
			target_include_directories(${l_IPM_target} PUBLIC ${l_IPM_include_dir})
		endforeach(l_IPM_target)
	endif()
endfunction()
