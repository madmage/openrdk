# This is the main CMake configuration file, you should always do "cmake ." from here and not from subdirs


# Cross compilation toolchains have to be specified before everything
# E.g.: cmake -DCMAKE_TOOLCHAIN_FILES=./build_tools/cmake/Toolchain-XXX.cmake
# or just editing the file below
IF(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/cross.cmake")
	IF("${CMAKE_CURRENT_SOURCE_DIR}/cross.cmake.template" IS_NEWER_THAN "${CMAKE_CURRENT_BINARY_DIR}/cross.cmake")
		MESSAGE(FATAL_ERROR "\n\nIt appears that cross.cmake.template is newer than your personal cross.cmake. \n"
		"Now you have FOUR choices:\n"
		"1) if you never made any changes in your personal cross.cmake, just cp cross.cmake.template cross.cmake;\n"
		"2) do as above and then make again your personal changes in cross.cmake;\n"
		"3) check the differences between cross.cmake.template and your personal manual.cmake and update the latter\n"
		"4) touch your personal cross.cmake (do this at your own risk, if someone changed something in the template, you will not use it).\n\n")
	ENDIF("${CMAKE_CURRENT_SOURCE_DIR}/cross.cmake.template" IS_NEWER_THAN "${CMAKE_CURRENT_BINARY_DIR}/cross.cmake")
	MESSAGE(STATUS "Using cross.cmake")
ELSE(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/cross.cmake")
	MESSAGE(STATUS "Creating cross.cmake")
	CONFIGURE_FILE(cross.cmake.template cross.cmake COPYONLY)
ENDIF(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/cross.cmake")
INCLUDE("${CMAKE_CURRENT_BINARY_DIR}/cross.cmake")

# Main project declaration
PROJECT(OpenRDK CXX C)

# Disable in-source builds
IF("${PROJECT_SOURCE_DIR}" STREQUAL "${PROJECT_BINARY_DIR}")
	MESSAGE(FATAL_ERROR "In-source builds are not allowed.")
ENDIF("${PROJECT_SOURCE_DIR}" STREQUAL "${PROJECT_BINARY_DIR}")

# Verbose or not verbose
IF($ENV{VERBOSE})
	MESSAGE(STATUS "Verbose mode on")
ELSE($ENV{VERBOSE})
	MESSAGE(STATUS "Verbose mode off (type 'VERBOSE=1 cmake .' to enable it)")
ENDIF($ENV{VERBOSE})

# Needed by CMake versione 2.6 or later (Run "cmake --help-policy CMP0003" for more information.)"
CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
#IF(COMMAND CMAKE_POLICY)
#	CMAKE_POLICY(SET CMP0003 OLD)
#ENDIF(COMMAND CMAKE_POLICY)
# Useful declaration for avoiding relative path
SET(OpenRDK_CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/build_tools/cmake")

# Version
SET(OpenRDK_V_MAJOR 2)
SET(OpenRDK_V_MINOR 1)
SET(OpenRDK_V_PATCH 8)

# Check for SVN and get current revision
INCLUDE(./build_tools/cmake/vcs-revision.cmake)
# Do not use revision information if I was unable to retrieve it
IF(NOT ${PROJECT_WC_REVISION} EQUAL 0)
	SET(OpenRDK_VERSION ${OpenRDK_V_MAJOR}.${OpenRDK_V_MINOR}.${OpenRDK_V_PATCH}.${PROJECT_WC_REVISION})
	SET(OpenRDK_V_REVISION ${PROJECT_WC_REVISION})
ELSE(NOT ${PROJECT_WC_REVISION} EQUAL 0)
	SET(OpenRDK_VERSION ${OpenRDK_V_MAJOR}.${OpenRDK_V_MINOR}.${OpenRDK_V_PATCH})
ENDIF(NOT ${PROJECT_WC_REVISION} EQUAL 0)

# Setting-up necessary paths
STRING(REGEX REPLACE "/src$" "" OpenRDK_ROOT ${OpenRDK_SOURCE_DIR})

# Create libext and binext
IF("${CMAKE_CURRENT_BINARY_DIR}" STREQUAL "${CMAKE_CURRENT_SOURCE_DIR}")
	SET(OpenRDK_OUTPUT_TREE "${CMAKE_CURRENT_SOURCE_DIR}/..")
ELSE("${CMAKE_CURRENT_BINARY_DIR}" STREQUAL "${CMAKE_CURRENT_SOURCE_DIR}")
	SET(OpenRDK_OUTPUT_TREE "${CMAKE_CURRENT_BINARY_DIR}")
ENDIF("${CMAKE_CURRENT_BINARY_DIR}" STREQUAL "${CMAKE_CURRENT_SOURCE_DIR}")
GET_FILENAME_COMPONENT(OpenRDK_OUTPUT_TREE ${OpenRDK_OUTPUT_TREE} ABSOLUTE)
IF(NOT EXISTS "${OpenRDK_OUTPUT_TREE}/libext")
	MESSAGE(STATUS "Creating directory libext in ${OpenRDK_OUTPUT_TREE}")
	FILE(MAKE_DIRECTORY "${OpenRDK_OUTPUT_TREE}/libext")
ENDIF(NOT EXISTS "${OpenRDK_OUTPUT_TREE}/libext")
IF(NOT EXISTS "${OpenRDK_OUTPUT_TREE}/binext")
	MESSAGE(STATUS "Creating directory binext in ${OpenRDK_OUTPUT_TREE}")
	FILE(MAKE_DIRECTORY "${OpenRDK_OUTPUT_TREE}/binext")
ENDIF(NOT EXISTS "${OpenRDK_OUTPUT_TREE}/binext")

# Operating System specific behaviors and switches
INCLUDE(${OpenRDK_CMAKE_MODULE_PATH}/os.cmake)

# If manual.cmake is older than its template, there is something wrong.
IF(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/manual.cmake")
	IF("${CMAKE_CURRENT_SOURCE_DIR}/manual.cmake.template" IS_NEWER_THAN "${CMAKE_CURRENT_BINARY_DIR}/manual.cmake")
		MESSAGE(FATAL_ERROR "\n\nIt appears that manual.cmake.template is newer than your personal manual.cmake. \n"
		"Now you have FOUR choices:\n"
		"1) if you never made any changes in your personal manual.cmake, just cp manual.cmake.template manual.cmake;\n"
		"2) do as above and then make again your personal changes in manual.cmake;\n"
		"3) check the differences between manual.cmake.template and your personal manual.cmake and update the latter\n"
		"4) touch your personal manual.cmake (do this at your own risk, if someone changed something in the template, you will not use it).\n\n")
	ENDIF("${CMAKE_CURRENT_SOURCE_DIR}/manual.cmake.template" IS_NEWER_THAN "${CMAKE_CURRENT_BINARY_DIR}/manual.cmake")
	MESSAGE(STATUS "Using manual.cmake")
ELSE(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/manual.cmake")
	MESSAGE(STATUS "Creating manual.cmake")
	CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/manual.cmake.template" "${CMAKE_CURRENT_BINARY_DIR}/manual.cmake" COPYONLY)
ENDIF(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/manual.cmake")
INCLUDE("${CMAKE_CURRENT_BINARY_DIR}/manual.cmake")

# Find and configure switches for external libraries and applications
INCLUDE(${OpenRDK_CMAKE_MODULE_PATH}/deps.cmake)

# Setting-up default output paths
GET_FILENAME_COMPONENT(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${OpenRDK_OUTPUT_TREE}/lib" ABSOLUTE)
GET_FILENAME_COMPONENT(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${OpenRDK_OUTPUT_TREE}/bin" ABSOLUTE)
GET_FILENAME_COMPONENT(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${OpenRDK_OUTPUT_TREE}/bin" ABSOLUTE)

### file2c
ADD_EXECUTABLE(file2c file2c.cpp)
GET_TARGET_PROPERTY(FILE2C_EXE file2c LOCATION)
# not available yet, thus skipping this for now
#INSTALL(TARGETS file2c RUNTIME DESTINATION ${RUNTIME_INSTALL_PATH})

MACRO(CONVERT_FILE2C file out varname)
	MESSAGE( "${file} => ${out}")
	ADD_CUSTOM_COMMAND(
		OUTPUT ${out}
		COMMAND ${FILE2C_EXE} 
		ARGS ${file} ${out} ${varname}
		DEPENDS file2c ${file}
		COMMENT "Converting ${file} to C..")
ENDMACRO(CONVERT_FILE2C file out varname)

# This will be used by the modules and by rdk-config
SET(RDKCORE_NAME "rdkcore")
SET(RDKCORE_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libraries)
SET(RDKCORE_LINK_DIRECTORIES ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
SET(RDKCORE_LIBRARIES ${RDKCORE_NAME})
# This are the same as before, but for makefile-style directive
# linking flags
SET(RDKCORE_LDFLAGS "")
FOREACH(dir ${RDKCORE_LINK_DIRECTORIES})
	SET(RDKCORE_LDFLAGS "${RDKCORE_LDFLAGS} -L${dir}")
ENDFOREACH(dir ${RDKCORE_LINK_DIRECTORIES})
# pre-processor flags (define)
SET(_tmp_RDKCORE_DEFINITIONS ${RDKCORE_DEFINITIONS})
SET(RDKCORE_DEFINITIONS "")
FOREACH(def ${_tmp_RDKCORE_DEFINITIONS})
	SET(RDKCORE_DEFINITIONS "${RDKCORE_DEFINITIONS} ${def}")
ENDFOREACH(def ${_tmp_RDKCORE_DEFINITIONS})
SET(RDKCORE_CPPFLAGS "${RDKCORE_DEFINITIONS}")
# compiling flags (include)
SET(RDKCORE_CXXFLAGS "")
FOREACH(dir ${RDKCORE_INCLUDE_DIR})
	SET(RDKCORE_CXXFLAGS "${RDKCORE_CXXFLAGS} -I${dir}")
ENDFOREACH(dir ${RDKCORE_INCLUDE_DIR})
#IF("${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)
#  SET(RDKCORE_LDFLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${RDKCORE_LDFLAGS}")
#  SET(RDKCORE_CPPFLAGS "${CMAKE_CXX_FLAGS} ${RDKCORE_CPPFLAGS}")
#ENDIF("${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)

# Creation of config.h
IF(CMAKE_CROSSCOMPILING)
	CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/config.h.cmake" "${CMAKE_CURRENT_SOURCE_DIR}/libraries/rdkcore/config-cross-${CROSS_ARCH}.h")
ELSE(CMAKE_CROSSCOMPILING)
	CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/config.h.cmake" "${CMAKE_CURRENT_SOURCE_DIR}/libraries/rdkcore/config-generic.h")
ENDIF(CMAKE_CROSSCOMPILING)

# Creation of openrdk_manifest.txt
CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/openrdk_manifest.txt.in" "${CMAKE_CURRENT_BINARY_DIR}/openrdk_manifest.txt")

# Creation of setenv and setenv.cmake
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/scripts/setenv.template" "${CMAKE_CURRENT_BINARY_DIR}/setenv" @ONLY)
execute_process(COMMAND "chmod" "+x" "setenv" WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/scripts/setenv.cmake.template" "${CMAKE_CURRENT_BINARY_DIR}/setenv.cmake" @ONLY)
message(STATUS "")
message(STATUS "..:: OpenRDK environment ::..")
execute_process(COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/scripts/rdkenv" "-m" "add" "${CMAKE_CURRENT_BINARY_DIR}" OUTPUT_VARIABLE msg OUTPUT_STRIP_TRAILING_WHITESPACE)
message(STATUS "${msg}")
add_custom_target(install_rdkenv COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/scripts/rdkenv --color install-me COMMENT Installing rdkenv)
execute_process(COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/scripts/rdkenv" "check-version" OUTPUT_VARIABLE msg OUTPUT_STRIP_TRAILING_WHITESPACE)
message(STATUS "${msg}")

# Creation of openrdk.cmake
SET(OpenRDK_FINDOPENRDK_CMAKE "${CMAKE_CURRENT_BINARY_DIR}/FindOpenRDK.cmake")
CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/FindOpenRDK.cmake.in" "${OpenRDK_FINDOPENRDK_CMAKE}" @ONLY)

MESSAGE(STATUS "")
MESSAGE(STATUS "..:: Variables ::..")
MESSAGE(STATUS "OpenRDK_VERSION = ${OpenRDK_VERSION}")
MESSAGE(STATUS "OpenRDK_ARCH = ${OpenRDK_ARCH}")
MESSAGE(STATUS "OpenRDK_OUTPUT_TREE = ${OpenRDK_OUTPUT_TREE}")
MESSAGE(STATUS "CMAKE_LIBRARY_OUTPUT_DIRECTORY = ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
MESSAGE(STATUS "CMAKE_RUNTIME_OUTPUT_DIRECTORY = ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
IF($ENV{VERBOSE})
	MESSAGE(STATUS "OpenRDK_FINDOPENRDK_CMAKE = ${OpenRDK_FINDOPENRDK_CMAKE}")
	MESSAGE(STATUS "OpenRDK_ROOT = ${OpenRDK_ROOT}")
	MESSAGE(STATUS "OpenRDK_SOURCE_DIR = ${OpenRDK_SOURCE_DIR}")
	MESSAGE(STATUS "RDKCORE_LDFLAGS = ${RDKCORE_LDFLAGS}")
	MESSAGE(STATUS "RDKCORE_CPPFLAGS = ${RDKCORE_CPPFLAGS}")
	MESSAGE(STATUS "RDKCORE_CXXFLAGS = ${RDKCORE_CXXFLAGS}")
	MESSAGE(STATUS "RDKCORE_DEFINITIONS = ${RDKCORE_DEFINITIONS}")
	MESSAGE(STATUS "RDKCORE_INCLUDE_DIR = ${RDKCORE_INCLUDE_DIR}")
	MESSAGE(STATUS "RDKCORE_LINK_DIRECTORIES = ${RDKCORE_LINK_DIRECTORIES}")
	MESSAGE(STATUS "RDKCORE_LIBRARIES = ${RDKCORE_LIBRARIES}")
ENDIF($ENV{VERBOSE})

IF("${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)
	MESSAGE(STATUS "")
	MESSAGE(STATUS "..:: Cross Compiling Detected ::..")
	MESSAGE(STATUS "CMAKE_CXX_COMPILER = ${CMAKE_CXX_COMPILER}")
	MESSAGE(STATUS "CMAKE_C_COMPILER = ${CMAKE_C_COMPILER}")
	MESSAGE(STATUS "CMAKE_AR = ${CMAKE_AR}")
	MESSAGE(STATUS "CMAKE_RANLIB = ${CMAKE_RANLIB}")
	MESSAGE(STATUS "CMAKE_LINKER = ${CMAKE_LINKER}")
	MESSAGE(STATUS "CMAKE_STRIP = ${CMAKE_STRIP}")
	MESSAGE(STATUS "CMAKE_OBJCOPY = ${CMAKE_OBJCOPY}")
	MESSAGE(STATUS "CMAKE_OBJDUMP = ${CMAKE_OBJDUMP}")
ENDIF("${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)

ENABLE_TESTING()

MESSAGE(STATUS "")

# Subdirectories
SUBDIRS(scripts)
SUBDIRS(libraries)
SUBDIRS(apps)

# Packages creation
SET(CPACK_PACKAGE_VERSION_MAJOR "${OpenRDK_V_MAJOR}")
SET(CPACK_PACKAGE_VERSION_MINOR "${OpenRDK_V_MINOR}")
SET(CPACK_PACKAGE_VERSION_PATCH "${OpenRDK_V_PATCH}")
SET(CPACK_GENERATOR "TGZ")
SET(CPACK_PACKAGE_INSTALL_DIRECTORY "CMake ${OpenRDK_V_MAJOR}.${OpenRDK_V_MINOR}")
SET(CPACK_PACKAGE_FILE_NAME "openrdk-binary-${OpenRDK_VERSION}-${CMAKE_SYSTEM_NAME}${CROSS_ARCH}")
SET(CPACK_SOURCE_PACKAGE_FILE_NAME "openrdk-source-${OpenRDK_VERSION}-${CMAKE_SYSTEM_NAME}${CROSS_ARCH}")
SET(CPACK_SOURCE_GENERATOR "TGZ")
SET(CPACK_INSTALL_DIRECTORIES "${OpenRDK_ROOT}/data;${OpenRDK_ROOT}/docs")
SET(CPACK_SOURCE_IGNORE_FILES
"/libraries/config.h$"
"/_CPack_Packages/"
"/CMakeCache.txt$"
"\\\\.dir/"
"\\\\.tar\\\\.gz$"
"\\\\.tar\\\\.Z$"
"\\\\.svn/"
"\\\\.cvsignore$"
"\\\\.swp$"
"~$"
"\\\\.#"
"/#"
"/CVS/"
"/cmake_install.cmake$"
"/CMakeOutput.log$"
"/CPackConfig.cmake$"
"/CPackSourceConfig.cmake$"
"/CTestTestfile.cmake$"
"/Makefile$"
"/Makefile2$"
"/CMakeFiles/"
"/\\\\.libs/"
"/\\\\.deps/"
"\\\\.o$"
"\\\\.a$"
"\\\\.lo$"
"\\\\.so$"
"\\\\.so\\\\.0$" 
"\\\\.so\\\\.0\\\\.0$" 
"\\\\.la$"
"Makefile\\\\.in$"
 )

INCLUDE(CPack)

# FIXME delete the following lines if no problem is found in next days
#EXECUTE_PROCESS(COMMAND ${OpenRDK_ROOT}/src/scripts/rdk-env-add.sh OUTPUT_VARIABLE setenvvar)
#MESSAGE(STATUS ${setenvvar})

SET(RDK_INSIDE_OpenRDK 1)
INCLUDE(${OpenRDK_ROOT}/src/build_tools/cmake/utils.cmake)
