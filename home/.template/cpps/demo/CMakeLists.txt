set (DEMOES
    )

foreach(DEMO ${DEMOES})
    message("add ${DEMO}")
    add_executable(${DEMO} ${DEMO}/${DEMO}.cpp)
    set_target_properties(${DEMO} PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
    target_link_libraries(${DEMO} ${COMMON_LIBS})
endforeach()
