IF (EXISTS ${PROJECT_SOURCE_DIR}/.svn)
	INCLUDE(${OpenRDK_CMAKE_MODULE_PATH}/FindSubversion.cmake)
	IF(Subversion_FOUND)
		Subversion_WC_INFO(${PROJECT_SOURCE_DIR} PROJECT)
		# Workaround for wrong retrieved information
		STRING(LENGTH ${PROJECT_WC_REVISION} tmpSVNINFO)
		IF(${tmpSVNINFO} GREATER 10)
			SET(PROJECT_WC_REVISION "0")
		ENDIF(${tmpSVNINFO} GREATER 10)
		MESSAGE("-- Current SVN revision is ${PROJECT_WC_REVISION}")
	ENDIF(Subversion_FOUND)
ELSE (EXISTS ${PROJECT_SOURCE_DIR}/.svn)
	# TODO: at each release, set current SVN revision here!
	SET(PROJECT_WC_REVISION 0)
	IF (EXISTS "${PROJECT_SOURCE_DIR}/rev.txt")
		FILE(READ "${PROJECT_SOURCE_DIR}/rev.txt" PROJECT_WC_REVISION)
		MESSAGE("-- Current SVN revision is ${PROJECT_WC_REVISION}")
	ENDIF (EXISTS "${PROJECT_SOURCE_DIR}/rev.txt")
ENDIF (EXISTS ${PROJECT_SOURCE_DIR}/.svn)

