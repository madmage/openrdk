# this one is important
SET(CMAKE_SYSTEM_NAME Linux)
#this one not so much
SET(CMAKE_SYSTEM_VERSION 1)
# necessary for OpenRDK purposes
SET(CMAKE_SYSTEM_PROCESSOR "geode")
SET(CROSS_ARCH "${CMAKE_SYSTEM_PROCESSOR}")

# Check validity of Cross Toolchain Dir
IF( NOT "x$ENV{OE_CROSS_DIR}x" STREQUAL "xx" )
	SET(OE_CROSS_DIR $ENV{OE_CROSS_DIR})
	SET(OE_TOOLCHAIN_DIR ${OE_CROSS_DIR})
ENDIF( NOT "x$ENV{OE_CROSS_DIR}x" STREQUAL "xx" )
IF( "x${OE_CROSS_DIR}x" STREQUAL "xx" )
	MESSAGE( FATAL_ERROR "Empty OE_CROSS_DIR variables. Please check your configuration." )
ENDIF( "x${OE_CROSS_DIR}x" STREQUAL "xx" )

IF( NOT "x$ENV{OE_CROSS_ADDONS_DIR}x" STREQUAL "xx" )
	SET(OE_CROSS_ADDONS_DIR $ENV{OE_CROSS_ADDONS_DIR})
ENDIF( NOT "x$ENV{OE_CROSS_ADDONS_DIR}x" STREQUAL "xx" )
IF( "x${OE_CROSS_ADDONS_DIR}x" STREQUAL "xx" )
	MESSAGE( FATAL_ERROR "Empty OE_CROSS_ADDONS_DIR variables. Please check your configuration." )
ENDIF( "x${OE_CROSS_ADDONS_DIR}x" STREQUAL "xx" )


SET(UNIX 1)
INCLUDE( "${OE_TOOLCHAIN_DIR}/toolchain-geode.cmake" )
# I hate Aldebaran... (so say we all...)
SET(T001CHAIN_DIR ${OE_TOOLCHAIN_DIR}/staging/geode-linux/usr/lib)
SET(OE_CMAKE_MODULE_PATH ${T001CHAIN_DIR}/cmake/modules)
INCLUDE(${T001CHAIN_DIR}/cmake/general.cmake)
SET(TOOLCHAIN_INCLUDE_DIRECTORIES ${OE_TOOLCHAIN_DIR}/staging/geode-linux/usr/include)
SET(TOOLCHAIN_LIBRARIES ${OE_TOOLCHAIN_DIR}/staging/geode-linux/usr/lib)

# This is necessary for pthread stuff
# see rdkcore/posixconstructs/posixsem.h
LIST(APPEND RDKCORE_DEFINITIONS -DLINUX)

LINK_DIRECTORIES(${OE_CROSS_ADDONS_DIR}/lib)
INCLUDE_DIRECTORIES(${OE_CROSS_ADDONS_DIR}/include)

# where is the target environment 
#SET(CMAKE_FIND_ROOT_PATH  /opt/eldk-2007-01-19/ppc_74xx /home/alex/eldk-ppc74xx-inst)

# search for programs in the build host directories
#SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
## for libraries and headers in the target directories
##SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
##SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

## Tests of working compilers are broken for OpenEmbedded Toolchain
## we avoid testing them
#INCLUDE(CMakeForceCompiler)
#CMAKE_FORCE_C_COMPILER("${CMAKE_C_COMPILER}" GNU)
#CMAKE_FORCE_CXX_COMPILER("${CMAKE_CXX_COMPILER}" GNU)


