function(check_package_compatibility a_APM_result)
	#This call is useless as we do not handle any argument. However, it could be if we check compiler compatibility.
	#APM_check_package_compatibility_parse_arguments(l_APM_check_package_compatibility ${ARGN})
  set(${a_APM_result} TRUE PARENT_SCOPE)
endfunction()

function(get_compatible_package_version_root a_APM_package_root a_APM_version a_APM_result)
	APM_get_compatible_package_version_root_parse_arguments(l_APM_get_compatible_package_version_root ${ARGN})
	APM_get_subdirectories(${a_APM_package_root} l_APM_version_dirs)

	#try to find a matching version
	foreach(l_APM_version_dir ${l_APM_version_dirs})
		set(l_APM_version_compatible FALSE)
		# first check that the project has been installed. If so, check version compatibility.
		#TODO add path to test file
		if(EXISTS ${a_APM_package_root}/${l_APM_version_dir}/install/)
			if(${l_APM_version_dir} VERSION_EQUAL ${a_APM_version})
				set(l_APM_version_compatible TRUE)
				set(${a_APM_result} ${a_APM_package_root}/${l_APM_version_dir} PARENT_SCOPE)
				break()
			else()
				#we assume that greater versions are backward compatible
				if(${l_APM_version_dir} VERSION_GREATER ${a_APM_version} AND NOT ${l_APM_get_compatible_package_version_root_EXACT})
					set(l_APM_version_compatible TRUE)
					set(${a_APM_result} ${a_APM_package_root}/${l_APM_version_dir} PARENT_SCOPE)
					break()
				endif()
			endif()
		endif()
	endforeach()
endfunction()

function(download_package_version a_APM_package_root a_APM_result a_APM_version)
	#construct the link to Eigen3 archive
	string(REPLACE "." "_" l_APM_underscore_version ${a_APM_version})
	set(l_APM_EigenLocation https://bitbucket.org/eigen/eigen/get/${a_APM_version}.tar.bz2)

	file(MAKE_DIRECTORY ${a_APM_package_root}/${a_APM_version}/download/)

	if(NOT EXISTS ${a_APM_package_root}/${a_APM_version}/download/${a_APM_version}.tar.bz2)
		file(DOWNLOAD ${l_APM_EigenLocation} ${a_APM_package_root}/${a_APM_version}/download/${a_APM_version}.tar.bz2
			STATUS l_APM_download_result
			SHOW_PROGRESS)


		list(GET l_APM_download_result 0 l_APM_download_result_code)

		if(NOT l_APM_download_result_code EQUAL 0)
			APM_message(FATAL "Unable to download Eigen.")
		endif()
	else()
		APM_message(INFO "File ${a_APM_package_root}/${a_APM_version}/download/${a_APM_version}.tar.bz2 already exist.")
	endif()

	file(MAKE_DIRECTORY ${a_APM_package_root}/${a_APM_version}/install/)

	execute_process(COMMAND ${CMAKE_COMMAND} -E tar xzf ${a_APM_package_root}/${a_APM_version}/download/${a_APM_version}.tar.bz2 WORKING_DIRECTORY ${a_APM_package_root}/${a_APM_version}/install RESULT_VARIABLE l_APM_extract_result)

	#TODO add error output from OUTPUT_VARIABLE, ERROR_VARIABLE
	if(NOT l_APM_extract_result EQUAL 0)
		APM_message(FATAL "Unable to extract Eigen.")
	endif()

	set(${a_APM_result} ${a_APM_package_root}/${a_APM_version} PARENT_SCOPE)
endfunction()

function(package_version_need_compilation a_APM_package_version_root a_APM_result)
	#This call is useless as we do not handle COMPONENTS in Eigen. However, it could be if we check compiler compatibility.
	#APM_package_version_need_compilation_parse_arguments(l_APM_package_version_need_compilation ${ARGN})

	#Eigen is header only. Hence no compilation is needed.
	set(${a_APM_result} FALSE PARENT_SCOPE)
endfunction()

function(configure_package_version a_APM_package_version_root)
	APM_configure_package_version_parse_arguments(l_APM_configure_package_version ${ARGN})

	APM_get_subdirectories(${a_APM_package_version_root}/install l_APM_subdirectory)

	list(LENGTH l_APM_subdirectory l_APM_subdirectory_length)
	if(${l_APM_subdirectory_length} GREATER 1)
		APM_message(FATAL "${a_APM_package_version_root}/install should only have one subdirectory corresponding to the commit id...")
	endif()


	set(l_APM_include_dir "${a_APM_package_version_root}/install/${l_APM_subdirectory}/")
	if(NOT DEFINED l_APM_configure_package_version_TARGETS)
		APM_message(WARN "Including directory ${l_APM_include_dir} globally.")
		include_directories(${l_APM_include_dir})
	else()
		APM_message(INFO "Including directory ${l_APM_include_dir} for targets ${l_APM_configure_package_version_TARGETS}.")
		foreach(l_APM_target ${l_APM_configure_package_version_TARGETS})
			target_include_directories(${l_APM_target} PUBLIC ${l_APM_include_dir})
		endforeach(l_APM_target)
	endif()
endfunction()
