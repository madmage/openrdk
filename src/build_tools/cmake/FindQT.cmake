IF (NOT "${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)
	IF(MACOSX)
		SET(QT_INCLUDE_DIR "QT_INCLUDE_DIR-NOTFOUND")
		SET(QT_LIBRARIES "QT_LIBRARIES-NOTFOUND")
		SET(QT_MOC_EXECUTABLE "QT_MOC_EXECUTABLE-NOTFOUND")
		FIND_PATH(QT_INCLUDE_DIR qapp.h /sw/include/qt)
		FIND_FILE(QT_LIBRARIES libqt-mt.dylib PATHS /sw/lib)
		FIND_FILE(QT_MOC_EXECUTABLE moc PATHS /sw/bin)
		IF(QT_INCLUDE_DIR AND QT_LIBRARIES AND QT_MOC_EXECUTABLE)
			SET(QT_FOUND 1)
			SET(QT_QT_LIBRARY ${QT_LIBRARIES})
		ENDIF(QT_INCLUDE_DIR AND QT_LIBRARIES AND QT_MOC_EXECUTABLE)
	ELSE(MACOSX)
		FIND_PACKAGE(Qt3 QUIET)
	ENDIF(MACOSX)
ELSE(NOT "${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)
	MESSAGE(STATUS "Qt3 support is not available for cross-compiled OpenRDK")
ENDIF (NOT "${CMAKE_CROSSCOMPILING}" STREQUAL TRUE)

IF(QT_FOUND)
	IF (LINUX64) # FIXME: CMake should use only the paths with lib64,
		     # but it doesn't. So, we fix that.
		FOREACH(lib ${QT_LIBRARIES})
			STRING(REPLACE "lib/" "lib64/" lib ${lib})
			LIST(APPEND tempList ${lib})
		ENDFOREACH(lib)
		SET(QT_LIBRARIES ${tempList})
		FOREACH(lib ${QT_QT_LIBRARY})
			STRING(REPLACE "lib/" "lib64/" lib ${lib})
			LIST(APPEND tempList ${lib})
		ENDFOREACH(lib)
		SET(QT_QT_LIBRARY ${tempList})
	ENDIF(LINUX64)
ENDIF(QT_FOUND)

