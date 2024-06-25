SET(V4L2_INCLUDE_DIR "V4L2_INCLUDE_DIR-NOTFOUND")

IF ("${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)
	IF ("${OpenRDK_ARCH}" STREQUAL "geode" )
		SET(V4L2_INCLUDE_DIR "${OE_CROSS_DIR}/include/linux/")
	ELSEIF ("${OpenRDK_ARCH}" STREQUAL "arm9" )
	FIND_PATH(V4L2_INCLUDE_DIR linux/videodev2.h
		${ARM9_CROSS_DIR}/${ARM_PREFIX}/libc/usr/include/
		NO_CMAKE_SYSTEM_PATH
		)
	ELSE ("${OpenRDK_ARCH}" STREQUAL "geode" )
		MESSAGE(STATUS "Video4linux driver support is not available for unknown architecture: [${OpenRDK_ARCH}]")
	ENDIF ("${OpenRDK_ARCH}" STREQUAL "geode" )


ELSE ("${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)

	FIND_PATH(V4L2_INCLUDE_DIR linux/videodev2.h
		/usr/local/include
		/usr/include
		)
ENDIF ("${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)

IF(V4L2_INCLUDE_DIR)
	SET(V4L2_FOUND "Yes")
ENDIF(V4L2_INCLUDE_DIR)

