# - Try to find OpenCV library installation
# See http://sourceforge.net/projects/opencvlibrary/
#
# The follwoing variables are optionally searched for defaults
#  OpenCV_ROOT_DIR:Base directory of OpenCv tree to use.
#  OpenCV_FIND_REQUIRED_COMPONENTS : FIND_PACKAGE(OpenCV COMPONENTS ..) 
#compatible interface. typically  CV CXCORE CVAUX HIGHGUI CVCAM .. etc.
#
# The following are set after configuration is done: 
#  OpenCV_FOUND
#  OpenCV_INCLUDE_DIR
#  OpenCV_LIBRARIES
#  OpenCV_LINK_DIRECTORIES
#
# deprecated:
#  OPENCV_* uppercase replaced by case sensitive OpenCV_*
#  OPENCV_EXE_LINKER_FLAGS
#  OPENCV_INCLUDE_DIR : replaced by plural *_DIRS
# 
# 2004/05 Jan Woetzel, Friso, Daniel Grest 
# 2006/01 complete rewrite by Jan Woetzel
# 1006/09 2nd rewrite introducing ROOT_DIR and PATH_SUFFIXES 
#   to handle multiple installed versions gracefully by Jan Woetzel
#
# tested with:
# -OpenCV 0.97 (beta5a):  MSVS 7.1, gcc 3.3, gcc 4.1
# -OpenCV 0.99 (1.0rc1):  MSVS 7.1
#
# www.mip.informatik.uni-kiel.de/~jw
# --------------------------------

IF("${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)

	IF ("${OpenRDK_ARCH}" STREQUAL "geode" )
		# be backward compatible:
		INCLUDE(${OE_CMAKE_MODULE_PATH}/OPENCVConfig.cmake)
		SET(OpenCV_FOUND ${OPENCV_FOUND})
		SET(OpenCV_INCLUDE_DIRS ${OPENCV_INCLUDE_DIR})
		SET(OpenCV_LIBRARIES ${OPENCV_LIBRARIES})
	ELSEIF ("${OpenRDK_ARCH}" STREQUAL "arm9" )

		FIND_PATH(OpenCV_INCLUDE_DIRS cv.h
		${ARM9_CROSS_DIR}/include
		${ARM9_CROSS_ADDONS_DIR}/include
		${ARM9_CROSS_DIR}/include/opencv
		${ARM9_CROSS_ADDONS_DIR}/include/opencv
		NO_CMAKE_SYSTEM_PATH
		)
		FIND_PATH(OpenCV_LINK_DIRECTORIES libcv.so
		${ARM9_CROSS_DIR}/lib
		${ARM9_CROSS_ADDONS_DIR}/lib
		NO_CMAKE_SYSTEM_PATH
		)
		IF(OpenCV_INCLUDE_DIRS)
			MESSAGE(STATUS "INCLUDE ${OpenCV_INCLUDE_DIRS}")
		ENDIF(OpenCV_INCLUDE_DIRS)
		
		IF(OpenCV_LINK_DIRECTORIES)
			MESSAGE(STATUS "LINK ${OpenCV_LINK_DIRECTORIES}")
		ENDIF(OpenCV_LINK_DIRECTORIES)
	
		SET(OpenCV_LIBRARIES "-lcxcore -lcv -lcvaux -lml")
		
		
		IF(OpenCV_INCLUDE_DIRS AND OpenCV_LINK_DIRECTORIES)
			SET(OpenCV_FOUND ON)
			SET(OPENCV_LIBRARIES   ${OpenCV_LIBRARIES} )
			SET(OPENCV_INCLUDE_DIR ${OpenCV_INCLUDE_DIRS} )
			SET(OPENCV_LINK_DIRECTORIES ${OpenCV_LINK_DIRECTORIES})
			SET(OPENCV_FOUND   ${OpenCV_FOUND})


 #     STRING(REGEX REPLACE ".*/([^/]*)$" "\\1" OPENCV_LIBRARIES ${OPENCV_LINK_DIRECTORIES})
			#STRING(REGEX REPLACE "/[^/]*$" "" OPENCV_LINK_DIRECTORIES ${OPENCV_LINK_DIRECTORIES})
		ENDIF(OpenCV_INCLUDE_DIRS AND OpenCV_LINK_DIRECTORIES)
	ELSE ("${OpenRDK_ARCH}" STREQUAL "geode" )
		MESSAGE(STATUS "OpenCV support is not available for unknown architecture")
	ENDIF ("${OpenRDK_ARCH}" STREQUAL "geode" )

ELSE("${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)
	# required cv components with header and library if COMPONENTS unspecified
	IF(NOT OpenCV_FIND_COMPONENTS)
		# default
		SET(OpenCV_FIND_REQUIRED_COMPONENTS   CV CXCORE CVAUX HIGHGUI )
		IF(WIN32)
			LIST(APPEND OpenCV_FIND_REQUIRED_COMPONENTS  CVCAM ) # WIN32 only actually
		ENDIF(WIN32)  
	ENDIF(NOT OpenCV_FIND_COMPONENTS)


	# typical root dirs of installations, exactly one of them is used
	SET(OpenCV_POSSIBLE_ROOT_DIRS
		"${OpenCV_ROOT_DIR}"
		"$ENV{OpenCV_ROOT_DIR}"  
		"$ENV{OPENCV_DIR}"  # only for backward compatibility deprecated by ROOT_DIR
		"$ENV{OPENCV_HOME}" # only for backward compatibility
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Intel(R) Open Source Computer Vision Library_is1;Inno Setup: App Path]"
		"$ENV{ProgramFiles}/OpenCV"
		/opt/local #Mac
		/usr/local
		/usr
		)


	# MIP Uni Kiel /opt/net network installation 
	# get correct prefix for current gcc compiler version for gcc 3.x  4.x
	IF(${CMAKE_COMPILER_IS_GNUCXX})
		IF(NOT OpenCV_FIND_QUIETLY)
			#MESSAGE(STATUS "Checking GNUCXX version 3/4 to determine  OpenCV /opt/net/ path")
		ENDIF (NOT OpenCV_FIND_QUIETLY)
		EXEC_PROGRAM(${CMAKE_CXX_COMPILER} ARGS --version OUTPUT_VARIABLE CXX_COMPILER_VERSION)  
		IF   (CXX_COMPILER_VERSION MATCHES ".*3\\.[0-9].*")
			SET(IS_GNUCXX3 TRUE)
			LIST(APPEND OpenCV_POSSIBLE_ROOT_DIRS /opt/net/gcc33/OpenCV )
		ENDIF(CXX_COMPILER_VERSION MATCHES ".*3\\.[0-9].*")  
		IF   (CXX_COMPILER_VERSION MATCHES ".*4\\.[0-9].*")
			SET(IS_GNUCXX4 TRUE)
			LIST(APPEND OpenCV_POSSIBLE_ROOT_DIRS /opt/net/gcc41/OpenCV )
		ENDIF(CXX_COMPILER_VERSION MATCHES ".*4\\.[0-9].*")
	ENDIF (${CMAKE_COMPILER_IS_GNUCXX})

	#
	# select exactly ONE OpenCV base directory/tree 
	# to avoid mixing different version headers and libs
	#
	FIND_PATH(OpenCV_ROOT_DIR 
		NAMES 
		cv/include/cv.h # windows
		include/opencv/cv.h # linux /opt/net
		include/cv/cv.h 
		include/cv.h 
		PATHS ${OpenCV_POSSIBLE_ROOT_DIRS})


	# header include dir suffixes appended to OpenCV_ROOT_DIR
	SET(OpenCV_INCDIR_SUFFIXES
		include
		include/cv
		include/opencv
		cv/include
		cxcore/include
		cvaux/include
		otherlibs/cvcam/include
		otherlibs/highgui
		otherlibs/highgui/include
		otherlibs/_graphics/include
		)

	# library linkdir suffixes appended to OpenCV_ROOT_DIR 
	SET(OpenCV_LIBDIR_SUFFIXES
		lib
		OpenCV/lib
		otherlibs/_graphics/lib
		)


	#
	# find incdir for each lib
	#
	FIND_PATH(OpenCV_CV_INCLUDE_DIR
		NAMES cv.h  
		PATHS ${OpenCV_ROOT_DIR} 
		PATH_SUFFIXES ${OpenCV_INCDIR_SUFFIXES} )
	FIND_PATH(OpenCV_CXCORE_INCLUDE_DIR   
		NAMES cxcore.h
		PATHS ${OpenCV_ROOT_DIR} 
		PATH_SUFFIXES ${OpenCV_INCDIR_SUFFIXES} )
	FIND_PATH(OpenCV_CVAUX_INCLUDE_DIR
		NAMES cvaux.h
		PATHS ${OpenCV_ROOT_DIR} 
		PATH_SUFFIXES ${OpenCV_INCDIR_SUFFIXES} )
	FIND_PATH(OpenCV_HIGHGUI_INCLUDE_DIR  
		NAMES highgui.h 
		PATHS ${OpenCV_ROOT_DIR} 
		PATH_SUFFIXES ${OpenCV_INCDIR_SUFFIXES} )
	FIND_PATH(OpenCV_CVCAM_INCLUDE_DIR
		NAMES cvcam.h 
		PATHS ${OpenCV_ROOT_DIR} 
		PATH_SUFFIXES ${OpenCV_INCDIR_SUFFIXES} )

	#
	# find sbsolute path to all libraries 
	# some are optionally, some may not exist on Linux
	#
	FIND_LIBRARY(OpenCV_CV_LIBRARY   
		NAMES cv opencv
		PATHS ${OpenCV_ROOT_DIR}  
		PATH_SUFFIXES  ${OpenCV_LIBDIR_SUFFIXES} )
	FIND_LIBRARY(OpenCV_CVAUX_LIBRARY
		NAMES cvaux
		PATHS ${OpenCV_ROOT_DIR}  PATH_SUFFIXES ${OpenCV_LIBDIR_SUFFIXES} )
	FIND_LIBRARY(OpenCV_CVCAM_LIBRARY   
		NAMES cvcam
		PATHS ${OpenCV_ROOT_DIR}  PATH_SUFFIXES ${OpenCV_LIBDIR_SUFFIXES} ) 
	FIND_LIBRARY(OpenCV_CVHAARTRAINING_LIBRARY
		NAMES cvhaartraining
		PATHS ${OpenCV_ROOT_DIR}  PATH_SUFFIXES ${OpenCV_LIBDIR_SUFFIXES} ) 
	FIND_LIBRARY(OpenCV_CXCORE_LIBRARY  
		NAMES cxcore
		PATHS ${OpenCV_ROOT_DIR}  PATH_SUFFIXES ${OpenCV_LIBDIR_SUFFIXES} )
	FIND_LIBRARY(OpenCV_CXTS_LIBRARY   
		NAMES cxts
		PATHS ${OpenCV_ROOT_DIR}  PATH_SUFFIXES ${OpenCV_LIBDIR_SUFFIXES} )
	FIND_LIBRARY(OpenCV_HIGHGUI_LIBRARY  
		NAMES highgui
		PATHS ${OpenCV_ROOT_DIR}  PATH_SUFFIXES ${OpenCV_LIBDIR_SUFFIXES} )
	FIND_LIBRARY(OpenCV_ML_LIBRARY  
		NAMES ml
		PATHS ${OpenCV_ROOT_DIR}  PATH_SUFFIXES ${OpenCV_LIBDIR_SUFFIXES} )
	FIND_LIBRARY(OpenCV_TRS_LIBRARY  
		NAMES trs
		PATHS ${OpenCV_ROOT_DIR}  PATH_SUFFIXES ${OpenCV_LIBDIR_SUFFIXES} )

	#
	# Logic selecting required libs and headers
	#
	SET(OpenCV_FOUND ON)

	FOREACH(NAME ${OpenCV_FIND_REQUIRED_COMPONENTS} )
		# only good if header and library both found   
		IF(OpenCV_${NAME}_INCLUDE_DIR AND OpenCV_${NAME}_LIBRARY)
			LIST(APPEND OpenCV_INCLUDE_DIRS ${OpenCV_${NAME}_INCLUDE_DIR} )
			LIST(APPEND OpenCV_LIBRARIES ${OpenCV_${NAME}_LIBRARY} )
		ELSE(OpenCV_${NAME}_INCLUDE_DIR AND OpenCV_${NAME}_LIBRARY)
			SET(OpenCV_FOUND OFF)
		ENDIF(OpenCV_${NAME}_INCLUDE_DIR AND OpenCV_${NAME}_LIBRARY)
	ENDFOREACH(NAME)

	#SET(OpenCV_INCLUDE_DIR "${OpenCV_INCLUDE_DIRS}")

	# get the link directory for rpath to be used with LINK_DIRECTORIES: 
	IF(OpenCV_CV_LIBRARY)
		GET_FILENAME_COMPONENT(OpenCV_LINK_DIRECTORIES ${OpenCV_CV_LIBRARY} PATH)
	ENDIF (OpenCV_CV_LIBRARY)

	MARK_AS_ADVANCED(
		OpenCV_ROOT_DIR
		OpenCV_INCLUDE_DIRS
		OpenCV_CV_INCLUDE_DIR
		OpenCV_CXCORE_INCLUDE_DIR
		OpenCV_CVAUX_INCLUDE_DIR
		OpenCV_CVCAM_INCLUDE_DIR
		OpenCV_HIGHGUI_INCLUDE_DIR
		OpenCV_LIBRARIES
		OpenCV_CV_LIBRARY
		OpenCV_CXCORE_LIBRARY
		OpenCV_CVAUX_LIBRARY
		OpenCV_CVCAM_LIBRARY
		OpenCV_CVHAARTRAINING_LIBRARY
		OpenCV_CXTS_LIBRARY
		OpenCV_HIGHGUI_LIBRARY
		OpenCV_ML_LIBRARY
		OpenCV_TRS_LIBRARY
		)

ENDIF ("${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)

SET(OpenCV_INCLUDE_DIR ${OpenCV_INCLUDE_DIRS})

# be backward compatible:
SET(OPENCV_LIBRARIES   ${OpenCV_LIBRARIES} )
SET(OPENCV_INCLUDE_DIR ${OpenCV_INCLUDE_DIRS} )
SET(OPENCV_LINK_DIRECTORIES ${OpenCV_LINK_DIRECTORIES})
SET(OPENCV_FOUND   ${OpenCV_FOUND})

# display help message
IF(NOT OPENCV_FOUND)
	# make FIND_PACKAGE friendly
	IF(NOT OpenCV_FIND_QUIETLY)
		IF(OpenCV_FIND_REQUIRED)
			MESSAGE(FATAL_ERROR
				"OpenCV required but some headers or libs not found. Please specify it's location with OpenCV_ROOT_DIR env. variable.")
		ELSE(OpenCV_FIND_REQUIRED)
			#MESSAGE(STATUS 
			#	"ERROR: OpenCV was not found.")
		ENDIF(OpenCV_FIND_REQUIRED)
	ENDIF(NOT OpenCV_FIND_QUIETLY)
ENDIF(NOT OPENCV_FOUND)
