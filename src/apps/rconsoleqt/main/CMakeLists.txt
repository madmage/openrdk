	
ADD_EXECUTABLE(rconsoleqt rconsoleqt.cpp)
TARGET_LINK_LIBRARIES(rconsoleqt rdkcore rdkrq_common rdkra_main dl)
SET_TARGET_PROPERTIES(rconsoleqt PROPERTIES COMPILE_FLAGS "${RDKCORE_CPPFLAGS} ${RDKCORE_CXXFLAGS}")
SET_TARGET_PROPERTIES(rconsoleqt PROPERTIES LINK_FLAGS "${RDKCORE_LDFLAGS}")

IF(NOT CYGWIN)
INSTALL(PROGRAMS ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/rconsoleqt DESTINATION bin)
ENDIF(NOT CYGWIN)

