SET(libv4l2_FOUND "No")
SET(libv4l2_INCLUDE_DIR "libv4l2_INCLUDE_DIR-NOTFOUND")
SET(libv4l2_LIBRARIES "libv4l2_LIBRARIES-NOTFOUND")
SET(libv4l2_LINK_DIRECTORIES "libv4l2_LINK_DIRECTORIES-NOTFOUND")

IF ("${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)

	IF ("${OpenRDK_ARCH}" STREQUAL "arm9" )
		FIND_PATH(libv4l2_INCLUDE_DIR libv4l2.h
			${ARM9_CROSS_DIR}/include
			${ARM9_CROSS_ADDONS_DIR}/include
			NO_CMAKE_SYSTEM_PATH
			)
		FIND_PATH(libv4l2_LINK_DIRECTORIES libv4l2.so
			${ARM9_CROSS_DIR}/lib
			${ARM9_CROSS_ADDONS_DIR}/lib
			NO_CMAKE_SYSTEM_PATH
			)
	ELSE ("${OpenRDK_ARCH}" STREQUAL "arm9" )
		MESSAGE(STATUS "libv4l2 support is not available for unknown architecture: [${OpenRDK_ARCH}]")
	ENDIF ("${OpenRDK_ARCH}" STREQUAL "arm9" )

ELSE ("${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)

	# FIXME use pkg-config instead
	FIND_PATH(libv4l2_INCLUDE_DIR libv4l2.h
		/usr/local/include
		/usr/include
		)
	FIND_PATH(libv4l2_LINK_DIRECTORIES libv4l2.so
		/usr/local/lib
		/usr/lib
		)

ENDIF ("${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)

IF(libv4l2_INCLUDE_DIR AND libv4l2_LINK_DIRECTORIES)
	SET(libv4l2_FOUND "Yes")
	SET(libv4l2_LIBRARIES "v4l2")
ENDIF(libv4l2_INCLUDE_DIR AND libv4l2_LINK_DIRECTORIES)

