# - Find Aldebaran library
# Find the native Aldebaran includes and library
# This module defines
#  ALDEBARAN_INCLUDE_DIR, where to find tiff.h, etc.
#  ALDEBARAN_LIBRARIES, libraries to link against to use Aldebaran.
#  ALDEBARAN_FOUND, If false, do not try to use Aldebaran.
#  also defined, but not for general use are
#  ALDEBARAN_LIBRARY, where to find the Aldebaran library.

IF( "x$ENV{AL_DIR}x" STREQUAL "xx" )
	SET( ENV{AL_DIR} /usr/local/opt/nao-sdk )
ENDIF( "x$ENV{AL_DIR}x" STREQUAL "xx" )
SET( AL_DIR "$ENV{AL_DIR}" )

SET( OE_CROSS_DIR "OE_CROSS_DIR-NOT_FOUND" )
IF( NOT "x$ENV{OE_CROSS_DIR}x" STREQUAL "xx" )
	SET(OE_CROSS_DIR $ENV{OE_CROSS_DIR})
ENDIF( NOT "x$ENV{OE_CROSS_DIR}x" STREQUAL "xx" )

SET(ALDEBARAN_FOUND 0)
IF(${OpenRDK_ARCH} STREQUAL "geode" OR ${OpenRDK_ARCH} STREQUAL "generic")
	IF(EXISTS ${AL_DIR} AND EXISTS ${OE_CROSS_DIR})
		IF (NOT "${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)
			# I hate Aldebaran... (so say we all...)
			INCLUDE( "${AL_DIR}/toolchain-pc.cmake" )
			SET(T001CHAIN_DIR ${AL_DIR}/lib)
			INCLUDE(${AL_DIR}/lib/cmake/general.cmake)
		ENDIF (NOT "${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)

		SET( PYTHONPATH "${TOOLCHAINDIR}" )
		SET(AL_CMAKE_MODULE_PATH "${TOOLCHAIN_DIR}/cmake/modules")
		SET(AL_DEPS ALCOMMON;ALMATH;LIBCORE;LIBVISION;TOOLS;ALVALUE)
		FOREACH(_dep ${AL_DEPS})
			INCLUDE(${AL_CMAKE_MODULE_PATH}/${_dep}Config.cmake)
			LIST(APPEND _all_inc ${${_dep}_INCLUDE_DIR})
			LIST(APPEND _all_lib ${${_dep}_LIBRARIES})
			LIST(APPEND _all_dep ${${_dep}_DEPENDS})
		ENDFOREACH(_dep ${AL_DEPS})

		LIST(REMOVE_DUPLICATES _all_dep)
		FOREACH(_dep ${_all_dep})
			INCLUDE(${AL_CMAKE_MODULE_PATH}/${_dep}Config.cmake)
			LIST(APPEND _all_inc ${${_dep}_INCLUDE_DIR})
			LIST(APPEND _all_lib ${${_dep}_LIBRARIES})
		ENDFOREACH(_dep ${_all_dep})

		LIST(REMOVE_DUPLICATES _all_inc)
		SET(ALDEBARAN_INCLUDE_DIR ${_all_inc})
		LIST(REMOVE_DUPLICATES _all_lib)
		SET(ALDEBARAN_LIBRARIES ${_all_lib})

		SET(ALDEBARAN_FOUND 1)

		FIND_PATH(AL_INC_DIR NAMES configcore.h PATHS ${ALDEBARAN_INCLUDE_DIR})
		EXECUTE_PROCESS(COMMAND grep ALCOMMON_REVISION ${AL_INC_DIR}/configcore.h
			COMMAND awk "{print $4}"
			COMMAND tr -d "\"\n\""
			OUTPUT_VARIABLE NaoQi_VERSION
			)
		STRING(REGEX REPLACE "\([0-9]+\).[0-9]+.[0-9]+" "\\1" NAOQI_VERSION_MAJOR ${NaoQi_VERSION})
		STRING(REGEX REPLACE "[0-9]+.\([0-9]+\).[0-9]+" "\\1" NAOQI_VERSION_MINOR ${NaoQi_VERSION})
		STRING(REGEX REPLACE "[0-9]+.[0-9]+.\([0-9]+\)" "\\1" NAOQI_VERSION_PATCH ${NaoQi_VERSION})
		MESSAGE(STATUS "Found NaoQi Version: ${NaoQi_VERSION}")
	ENDIF(EXISTS ${AL_DIR} AND EXISTS ${OE_CROSS_DIR})
ENDIF(${OpenRDK_ARCH} STREQUAL "geode" OR ${OpenRDK_ARCH} STREQUAL "generic")

