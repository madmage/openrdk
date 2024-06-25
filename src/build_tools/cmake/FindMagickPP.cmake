
SET(MagickPP_FOUND "No")
SET(MagickPP_INCLUDE_DIR "MagickPP_INCLUDE_DIR-NOTFOUND")
SET(MagickPP_LINK_DIRECTORIES "MagickPP_LINK_DIRECTORIES-NOTFOUND")
SET(MagickPP_LIBRARIES "")

IF (NOT "${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)
	FIND_PATH(MagickPP_INCLUDE_DIR Magick++.h
		/opt/local/include/ImageMagick
		/usr/include
		/usr/include/ImageMagick
		)

	FIND_LIBRARY(MagickPP_LINK_DIRECTORIES Magick++
		PATHS
		/usr/lib
		)
ELSE(NOT "${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)
	IF ("${OpenRDK_ARCH}" STREQUAL "arm9" )
		FIND_PATH(MagickPP_INCLUDE_DIR Magick++.h
			${ARM9_CROSS_DIR}/include
			${ARM9_CROSS_ADDONS_DIR}/include
			${ARM9_CROSS_DIR}/include/ImageMagick
			${ARM9_CROSS_ADDONS_DIR}/include/ImageMagick
			NO_CMAKE_SYSTEM_PATH
		)
		FIND_LIBRARY(MagickPP_LINK_DIRECTORIES Magick++
			${ARM9_CROSS_DIR}/lib
			${ARM9_CROSS_ADDONS_DIR}/lib
			NO_CMAKE_SYSTEM_PATH
		)
	ELSE ("${OpenRDK_ARCH}" STREQUAL "arm9" )
		MESSAGE(STATUS "ImageMagick (Magick++) support is not available for arch: ${OpenRDK_ARCH}")
	ENDIF ("${OpenRDK_ARCH}" STREQUAL "arm9" )
ENDIF (NOT "${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)

IF(MagickPP_INCLUDE_DIR AND MagickPP_LINK_DIRECTORIES)
	SET(MagickPP_FOUND "Yes")
	STRING(REGEX REPLACE ".*/([^/]*)$" "\\1" MagickPP_LIBRARIES ${MagickPP_LINK_DIRECTORIES})
	STRING(REGEX REPLACE "/[^/]*$" "" MagickPP_LINK_DIRECTORIES ${MagickPP_LINK_DIRECTORIES})
ENDIF(MagickPP_INCLUDE_DIR AND MagickPP_LINK_DIRECTORIES)

