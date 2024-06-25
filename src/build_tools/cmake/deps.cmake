INCLUDE(${OpenRDK_CMAKE_MODULE_PATH}/prettymessage.cmake)

# This should be used instead manual adding.
# It ensures main OpenRDK target (aka rdkcore) will be compiled with found libraries
LIST(APPEND _rdkcore_include_directories "")
LIST(APPEND _rdkcore_link_directories "")
LIST(APPEND _rdkcore_libraries "")
LIST(APPEND _rdkcore_definitions "")
MACRO(_RDK_ADD_LIB LNAME required)
	info("${LNAME} found")
	verbose("   ${LNAME}_LIBRARIES = ${${LNAME}_LIBRARIES}")
	verbose("   ${LNAME}_INCLUDE_DIR = ${${LNAME}_INCLUDE_DIR}")
	verbose("   ${LNAME}_LINK_DIRECTORIES = ${${LNAME}_LINK_DIRECTORIES}")
	verbose("   ${LNAME}_DEFINITIONS = ${${LNAME}_DEFINITIONS}")
	IF("${required}" STREQUAL "required")
		LIST(APPEND _rdkcore_include_directories ${${LNAME}_INCLUDE_DIR})
		LIST(APPEND _rdkcore_link_directories ${${LNAME}_LINK_DIRECTORIES})
		LIST(APPEND _rdkcore_libraries ${${LNAME}_LIBRARIES})
	ENDIF("${required}" STREQUAL "required")
	LIST(APPEND _rdkcore_definitions ${${LNAME}_DEFINITIONS})
	SET(FINDOPENRDK_LIBRARIES_SECTION "${FINDOPENRDK_LIBRARIES_SECTION}
SET(${LNAME}_FOUND YES)
SET(${LNAME}_INCLUDE_DIR \"${${LNAME}_INCLUDE_DIR}\" )
SET(${LNAME}_LINK_DIRECTORIES \"${${LNAME}_LINK_DIRECTORIES}\" )
SET(${LNAME}_LIBRARIES \"${${LNAME}_LIBRARIES}\" )
SET(${LNAME}_DEFINITIONS \"${${LNAME}_DEFINITIONS}\" )
")
ENDMACRO(_RDK_ADD_LIB LNAME)

# Used for required libraries
MACRO(_RDK_REQUIRED_LIB LNAME)
INCLUDE (${OpenRDK_CMAKE_MODULE_PATH}/Find${LNAME}.cmake)
IF(${LNAME}_FOUND)
	_RDK_ADD_LIB(${LNAME} required)
ELSE(${LNAME}_FOUND)
	error("${LNAME} not found, it is REQUIRED to build the RDK")
ENDIF(${LNAME}_FOUND)
ENDMACRO(_RDK_REQUIRED_LIB LNAME)

# Used for optional libraries
MACRO(_RDK_OPTIONAL_LIB LNAME)
INCLUDE (${OpenRDK_CMAKE_MODULE_PATH}/Find${LNAME}.cmake)
IF(${LNAME}_FOUND)
	_RDK_ADD_LIB(${LNAME} optional)
ELSE(${LNAME}_FOUND)
	info("${LNAME} not found but it is not required")
ENDIF(${LNAME}_FOUND)
ENDMACRO(_RDK_OPTIONAL_LIB LNAME)

info("")
info("..:: Required external libraries ::..")
### Library: GSL
_RDK_REQUIRED_LIB(GSL)
### Library: libxml2
_RDK_REQUIRED_LIB(LIBXML2)
### Threads
_RDK_REQUIRED_LIB(Threads)

info("")
info("..:: Optional external libraries ::..")

### PkgConfig
INCLUDE(FindPkgConfig)
IF(PKG_CONFIG_FOUND)
	info("pkg-config found")
	verbose("   PKG_CONFIG_EXECUTABLE = ${PKG_CONFIG_EXECUTABLE}")
ELSE(PKG_CONFIG_FOUND)
	info("pkg-config not found, but it is not required")
ENDIF(PKG_CONFIG_FOUND)

### Library: CPPunit
_RDK_OPTIONAL_LIB(CPPUNIT)
### Library: GLUT
_RDK_OPTIONAL_LIB(GLUT)
### Library: Aldebaran
_RDK_OPTIONAL_LIB(ALDEBARAN)
### Library: ImageMagick's Magick++
_RDK_OPTIONAL_LIB(MagickPP)
### Library: OpenCV
_RDK_OPTIONAL_LIB(OpenCV)
### Library: libv4l2
_RDK_OPTIONAL_LIB(libv4l2)
### Library: GeoTIFF library
_RDK_OPTIONAL_LIB(GEOTIFF)
### Library: video4linux 2
_RDK_OPTIONAL_LIB(V4L2)
### Library: JPEG library
_RDK_OPTIONAL_LIB(JPEG)
### Library: OpenGL
_RDK_OPTIONAL_LIB(OPENGL)

# Player/Stage
_RDK_OPTIONAL_LIB(PLAYER)

### Library: QT
_RDK_OPTIONAL_LIB(QT)
IF(QT_FOUND)
	verbose("   QT_QT_LIBRARY = ${QT_QT_LIBRARY}")
	verbose("   QT_MOC_EXECUTABLE = ${QT_MOC_EXECUTABLE}")
	verbose("   QT_UIC_EXECUTABLE = ${QT_UIC_EXECUTABLE}")
	SET(FINDOPENRDK_LIBRARIES_SECTION "${FINDOPENRDK_LIBRARIES_SECTION}
SET(QT_QT_LIBRARY "${QT_QT_LIBRARY}")
SET(QT_MOC_EXECUTABLE "${QT_MOC_EXECUTABLE}")
SET(QT_UIC_EXECUTABLE "${QT_UIC_EXECUTABLE}")
")
ELSE(QT_FOUND)
	IF(COMPILE_RCONSOLE OR COMPILE_CONFIGBUILDER)
		error("QT3 not found, it is required to build RConsole and ConfigBuilder:\n"
			"either set COMPILE_RCONSOLE and COMPILE_CONFIGBUILDER to 0 or install qt3-dev package")
	ELSE(COMPILE_RCONSOLE OR COMPILE_CONFIGBUILDER)
		info("QT3 not found, but it is not required (but you will not compile RConsoleQt and configbuilder)")
	ENDIF(COMPILE_RCONSOLE OR COMPILE_CONFIGBUILDER)
ENDIF(QT_FOUND)

# we are now ready to set the global variables
LIST(REMOVE_DUPLICATES _rdkcore_include_directories)
LIST(REMOVE_DUPLICATES _rdkcore_link_directories)
LIST(REMOVE_DUPLICATES _rdkcore_libraries)
LIST(REMOVE_DUPLICATES _rdkcore_definitions)

### Ruby: old stuff (not used anymore
#IF(COMPILE_RUBY)
#  IF(NOT RUBY_FOUND)
#    FIND_PACKAGE(Ruby REQUIRED)

#    # cmake non mette RUBY_FOUND a 1 esplicitamente: lo mettiamo noi
#    IF(EXISTS ${RUBY_INCLUDE_PATH})
#      SET(RUBY_FOUND 1)
#    ENDIF(EXISTS ${RUBY_INCLUDE_PATH})

#    IF(NOT RUBY_FOUND)
#      MESSAGE(STATUS "Ruby not found, but it is not required")
#    ENDIF(NOT RUBY_FOUND)
			
#    SET(RUBY_LIBRARY ruby)
#  ENDIF(NOT RUBY_FOUND)
		 
#  IF(RUBY_FOUND)
#    MESSAGE(STATUS "About Ruby:")
#    MESSAGE(STATUS "   RUBY_INCLUDE_PATH: ${RUBY_INCLUDE_PATH}")
#    MESSAGE(STATUS "   RUBY_EXECUTABLE: ${RUBY_EXECUTABLE}")
#    MESSAGE(STATUS "   RUBY_LIBRARY: ${RUBY_LIBRARY}")
			
#    INCLUDE_DIRECTORIES(${RUBY_INCLUDE_PATH})
#  ENDIF(RUBY_FOUND)
#ENDIF(COMPILE_RUBY)
